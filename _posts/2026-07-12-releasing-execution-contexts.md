---
title: "Releasing Execution Contexts"
author: ysbaddaden
categories: project
tags: [multithreading]
---

[Two and a half years ago](./2024-02-09-84codes-manas-mt.md), with the
invaluable support from 84codes, we re-examined the multithreading model
inherited from Crystal 0.28 (preview MT).

There are different ways to spread an application to multiple CPU cores. So far,
preview MT proposed a simple solution, and it worked great for many cases, yet
sometimes we need more control over where and how a specific piece of code must
run.

- Sometimes we need a fiber to own a thread, notably GUI and game loops.
- Sometimes we need a set of fibers to run concurrently.
- Sometimes we need fibers to scale to as many CPU cores as needed.

Inspired by Kotlin contexts, we realized that we didn't have to pick just
one model. What if we designed an _interface_ instead?

Hence came **Execution Contexts**. Plural, because there are multiple ways to
orchestrate fibers across one to many threads. Ultimately we plan to make the
interface public, so you may write your own models.

## The default execution context

Applications run in a default context that is automatically created on the main
thread. It's a parallel context that defaults to a parallelism of 1, so fibers
run concurrently on just one thread. This avoids a breaking change to existing
applications that may not be ready for MT.

You can resize the default context to increase parallelism, making it truly
parallel, and letting it automatically scale fibers across CPU cores as needed
at runtime:

```
Fiber::ExecutionContext.default.resize(maximum: System.cpu_count)
```

You can keep it concurrent and start additional contexts to control the
execution and let the OS preempt the threads:

```
parallel = Fiber::ExecutionContext::Parallel.new("MT", maximum: 4)
parallel.spawn { }
```

You can keep it single-threaded if you don't need parallelism, or let users
determine the parallelism through a `--threads N` argument.

Your application, your choice.

## What do execution contexts provide?

Execution contexts allow you to start one or many fiber orchestrators to run
fibers in different manners. Fibers are tied to their execution context, and the
execution of fibers depends on the context they belong to.

We currently provide three different context types:

- **Concurrent**: Fibers spawned into the context run concurrently to each
  other, and will never run in parallel; they only run in parallel to fibers
  running in other contexts.

- **Parallel**: Fibers spawned in a parallel context run concurrently and in
  parallel to each other, in addition to fibers running in other contexts. The
  context automatically scales to multiple CPU cores, up to the configured
  maximum.

- **Isolated**: Spawn a single fiber to a system thread. The fiber owns the
  thread for its whole lifetime. The fiber can block the thread however it wants
  (it owns it) with no impact on the rest of the application.

## Can execution contexts communicate?

Fibers can always communicate and synchronize with any other fibers, regardless
of the execution context in which they run. Use I/O, `Channel` and `Sync` types
normally.

Note that cross context communication requires more synchronization than
internal communication, and can thus be slower. This is mostly noticeable in
extreme situations, notably benchmarks.

## How are execution contexts different from the 'preview MT' model?

Preview MT starts a fixed number of threads and ties each fiber to a single
thread on which it is always resumed. You have no control over where a fiber
would start aside from "spawn on the current thread of the current fiber"; you
can't isolate a fiber to a thread, plus other limitations.

Fibers can get stuck on one thread busy running a CPU-intensive work, while
other threads are idle. A slow `getaddrinfo` DNS request, for example, might
block your whole application from making any progress, or event fail to respond
to Ctrl+C or SIGINT to terminate the process.

Execution contexts solve all these issues.

## What changes?

The fiber scheduler has seen a complete overhaul. It is nothing like before. Not
only is it faster than the legacy schedulers, including both single thread and
preview MT, fibers will now automatically scale to as many CPU cores as needed
at runtime.

### The `CRYSTAL_WORKERS` environment variable

The `CRYSTAL_WORKERS` environment variable is no longer used by default. You can
use it manually to resize the default context, or start a parallel context. For
example:

```
maximum = ENV["CRYSTAL_WORKERS"]?.try(&.to_i?) || 4
Fiber::ExecutionContext.default.resize(maximum)
```

## Breaking changes

We have kept the breaking changes to a minimum and expect most applications to
continue running normally by keeping their default context concurrent.

If you experience issues, you may revert to the legacy, single-threaded,
scheduler using the `without_mt` compilation flag.

The `preview_mt` compilation flag is still supported; using it reverts to the
legacy, multi-threaded, preview scheduler.

The `-Dpreview_mt -Dexecution_context` combinaition of flags is still supported,
and won't revert to the legacy preview MT scheduler.

> **WARNING:**
> You are heavily encouraged to upgrade to execution contexts because we can't
> guarantee legacy support will continue in upcoming releases.
>
> If you need the `without_mt` or `preview_mt` flag, and it's unrelated to the
> below breaking changes, then we consider this to be a bug in the Crystal
> runtime.
>
> Please report any issues!

### 1. Fibers can switch threads (parallel contexts)

**Unlike the previous models (single-threaded and preview MT), the execution of
Fibers can move to another thread at runtime.**

Fibers spawned in a parallel context can be resumed by any thread in the
context. Fibers can start on one system thread, wait on I/O or a channel, then
be resumed by another thread in the context. This feature is known as work
stealing, and allows to scale fibers across CPU cores.

### 2. Schedulers can switch threads on blocking syscalls

**Unlike the previous schedulers (single-threaded and preview MT), the new
schedulers can move to another thread at runtime.**

A scheduler runs fibers sequentially on a single thread. The previous models
kept schedulers tied to their thread, but with execution contexts schedulers can
jump to another thread.

This can happen for some specific syscalls, such as `getaddrinfo(3)` that can
block the current thread and thus block the other fibers from progressing. When
that happens the scheduler can move to another thread to continue executing
runnable fibers while the current thread is blocked on the syscall. When the
syscall returns, the fiber is stopped and will eventually be resumed on the new
thread.

This applies to both concurrent and parallel contexts, including the default
context. It doesn't apply to the isolated context where blocking the thread is
the expected behavior.

We don't expect many applications to break, unless you rely on external C
libraries that expect to keep running on the main thread, or heavily rely on
thread locals. In that case, you may backup and restore thread-local state, or
consider isolated contexts.

### 3. Execution contexts don't support the `spawn(same_thread: true)` argument

This impacts the preview MT model. The argument is deprecated and the behavior
depends on the execution context:

The concurrent execution context simple ignores the `same_thread` argument
(noop).

The parallel execution context ignores `same_thread: false` (noop), but doesn't
support `same_thread: true` argument and will raise an exception at runtime
because that feature can't be guaranteed.

The default execution context is parallel, so `same_thread: true` will raise an
exception at runtime, even if you never resize the context to opt in to MT;
because the context might be resized in the future.

The isolated context can't directly spawn fibers, but instead spawns into the
default context or another specified context, so the behavior depends on the
target context.

#### How to fix the `same_thread` breaking change?

If the value for `same_thread` is set to `false` you can safely drop the
argument.

If set to `true`, you will have to investigate if there is an actual issue
regarding parallelism.

If there is an issue, you can either fix the issue (for example by using `Sync`
primitives), or start a concurrent execution context and spawn the fibers that
can't run in parallel there, or choose to not resize the default context (no
parallelism until you opt-in).

In any case, drop the argument.

## Notes

Auto-scaling roughly occurs every 100 ms, and stems from the idea that there's
no need to spread work until it's required. Another name for the feature is
"slow-parallelism". While it improves efficiency, it can alter parallelism
expectations, especially in benchmarks that may finish before the executable
needs to scale to multiple threads. That's the point of the feature, yet it
defeats the point of a benchmark.
