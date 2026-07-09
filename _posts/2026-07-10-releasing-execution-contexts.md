---
title: "Releasing Execution Contexts"
author: ysbaddaden
categories: project
tags: [multithreading]
---

Two and a half years ago and with the invaluable support from 84codes we decided
to rethink the multithreading model inherited from Crystal 0.28 (preview MT), by
analyzing its strenghs and shortcomings.

There are different ways to spread an application to multiple CPU cores. While
we love the runtime model proposed by Go for example, we sometimes need more
control over where and how a specific piece of code must run.

- Sometimes we need a fiber to own a thread, notably GUI and game loops.
- Sometimes we need a set of fibers to run concurrently.
- Sometimes we need fibers to scale to as many CPU cores as needed.

Inspired by Kotlin contexts, we realized that we didn't have to choose just
one model. What if we designed an _interface_ instead?

Hence came **Execution Contexts**. Plural, because there are multiple ways to
orchestrate fibers across one to many threads. Ultimately we plan to make the
interface public, so you may write your own models.

## The default execution context

Applications run in the default execution context that starts on the main
thread. It's a parallel context that defaults to a parallelism of 1, and will
thus only run concurrently on a single thread. This avoids a breaking change to
existing applications that may not be ready for MT.

You can resize the default context to increase the parallelism and make it truly
parallel and let it autoscale fibers across CPU cores as needed at runtime:

```
Fiber::ExecutionContext.default.resize(maximum: System.cpu_count)
```

You can keep it concurrent and start additional contexts to control the
execution and let the OS preempt the threads:

```
parallel = Fiber::ExecutionContext::Parallel.new("MT", maximum: 4)
parallel.spawn { }
```

You can keep it single threaded if you don't need parallelism, or let users
determine the parallelism through a `--threads N` argument.

Your application. Your choice.

## What do execution contexts provide?

Execution contexts allow you to start one or many fiber orchestrators to run
fibers in different manners. Fibers are tied to their execution context, and the
execution of fibers depend on its context.

We currently provide three different context types:

- **Concurrent**: Fibers spawned into the context run concurrently to each
  others, and will never run in parallel, they only run in parallel to fibers
  running in other contexts.

- **Parallel**: Fibers spawned in a parallel context run concurrently and in
  parallel to each others, in addition to fibers running in other contexts. The
  context auto scales to many CPU cores.

- **Isolated**: Spawn a single fiber to a system thread. The fiber owns the
  thread for its whole lifetime. The fiber can block the thread however it wants
  (it owns it) with no impact on the rest of the application.

## Can execution contexts communicate?

Fibers run normally in any context. Fibers can always communicate and
synchronize with other fibers regardless of their context. Use I/O, `Channel`
and `Sync` types normally.

Note that cross context communication requires more synchronization than
internal communication, and can thus be slower. This is mostly noticeable in
extreme situations, notably benchmarks.

## How are execution contexts different from the 'preview MT' model?

Preview MT starts a fixed number of threads, and ties each fiber to one thread
where it would always be resumed on. You have no control over where a fiber
would start aside from "spawn on the current thread of the current fiber"; you
can't isolate a fiber to a thread, and more.

Fibers could get stuck on one thread busy running a CPU heavy computation, while
other threads are idle. A slow `getaddrinfo` DNS request for example might block
your whole application from making any progress, maybe even be incapable to
respond to Ctrl+C or SIGINT to terminate the process.

Execution contexts solves all these issues.

## What changes?

The fiber scheduler has seen a complete overhaul. It is nothing like before. Not
only is it faster than the legacy schedulers, including both single thread and
preview MT, fibers will now autoscale to as many CPU cores as needed.

## Breaking changes

We kept the breaking changes to a minimum. We expect most applications to
continue running normally by keeping their default context concurrent.

If you experience issues, you may revert to the legacy, single threaded,
scheduler using the `without_mt` compilation flag.

> [!WARNING]
> If you need the `without_mt` flag, and it's unrelated to the below breaking
> change, then we consider this to be a bug in the Crystal runtime.
>
> Please report the issue!

The `preview_mt` compilation flag is still supported for the time being. Using
the flag will revert to the legacy, multi threaded, preview scheduler. You are
heavily encouraged to upgrade to execution contexts because support will
disappear at some point.

> [!NOTE]
> The `-Dpreview_mt -Dexecution_context` combo of flags is still supported, and
> won't revert to the legacy preview MT scheduler.

### 1. Schedulers switch threads on blocking syscalls

**Unlike the previous schedulers (single threaded and preview MT), the new
schedulers can move to another thread at runtime.**

This can happen for some specific syscalls, such as `getaddrinfo(3)` that can
block the current thread and thus block the other fibers from progressing. The
syscall will keep executing in the current thread, but the scheduler will be
resumed on another thread, that will resumed another fiber; when the syscall
returns, the blocked fiber will be enqueued back into its context.

This applies to both the concurrent and parallel contexts, including the default
context. It doesn't apply to the isolated context where blocking the thread is
expected.

We don't expect many applications to break, unless you rely on external C
libraries that expect to keep running on the main thread, or heavily rely on
thread locals. In that case, you may backup/restore thread local state, or
consider isolated contexts.

### 2. Execution contexts don't support the `spawn(same_thread: true)` argument

This is affecting the preview MT model. The argument is deprecated and the
behavior depends on the execution context:

The concurrent execution context skips `same_thread` argument (noop).

The parallel schedulers skip the `same_thread: false` argument (noop), but don't
support the `same_thread: true` argument by design and will raise an exception
at runtime.

The default execution context is parallel, so `same_thread: true` will raise an
exception at runtime.

The isolated context can't directly spawn fibers, but instead spawns into the
default context or another specified context, so the behavior depends on the
target context.

#### How to fix the `same_thread` breaking change?

If the value for `same_thread` is set to `false` you can safely drop the
argument.

If set to `true`, you will have to investigate if there is an actual
parallelism issue.

If there is an issue, you can either fix the issue (for example by using `Sync`
primitives), or start a concurrent execution context and spawn the fibers that
can't run in parallel there, or choose to not resize the default execution
context (no parallelism until you opt-in).

In any case, you can now drop the argument.

## Notes

Auto scaling roughly happens every 100ms, and stems from the idea that there's
no need to eagerly spread work across until it's needed. Another name for the
feature is "slow parallelism". While it improves efficiency, this can affect
parallelism expectations, especially in benchmarks that can finish before the
executable ever needed to scale to multiple threads. That's the whole point of
the feature, but it defeats the point of the benchmark.
