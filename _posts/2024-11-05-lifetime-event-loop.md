---
title: "A new Event Loop for UNIX operating systems"
author: straight-shoota,ysbaddaden
summary: >
  We're changing how the event loop operates. This improves performance,
  removes `libevent` as a runtime dependency, and paves the way to
  multi-threading.
categories: technical
tags: [feature, eventloop, concurrency, 84codes]
---

A core component of Crystal's concurrency model is the **event loop**. It
integrates asynchronous operations into the runtime, enabling other fibers to
run while one fiber waits to read data on a socket, for example.

We're changing how the event loop operates under the hood on Unix systems in [#14996].

The new implementation integrates the Crystal event loop directly with system
selectors, [`epoll`](https://linux.die.net/man/7/epoll) (Linux, Android) and
[`kqueue`](https://man.freebsd.org/cgi/man.cgi?kqueue) (BSDs, macOS) instead of
going through [`libevent`](https://libevent.org/).

We're removing an external dependency and take control over a core runtime
feature. It also changes how file descriptors are treated: instead of being
added and removed on every blocking IO operation, the file descriptors are now
added once and kept for their full lifetime, which is how epoll and kqueue have
been designed. This reduces overhead and improves performance.

This post highlights the relevant information for users.

More technical details are available in [RFC #0009].

## Effects

The new implementation has been merged into `master` and is available in
[nightly builds](/install/nightlies).

No changes in user code are required, everything plugs right in.

The new implementation is supported on Linux, macOS, FreeBSD and Android and
automatically enabled on these systems. Read [more about
availability][availability] in the RFC.

For the time being other UNIX operating systems still use the `libevent` event
loop by default (regressions, issues or untested). You can still force enable it
using `-Devloop=kqueue` (BSDs) or `-Devloop=epoll` (e.g. Solaris).

Windows is unaffected and keeps using `IOCP`.

Dropping `libevent` removes an external runtime dependency from Crystal
programs.

## Caveats

In some cases the new implementation may cause issues. You can switch
back to the old event loop implementation with the compile-time flag
`-Devloop=libevent`.

We are aware of some potential regressions but believe they are quite rare and
should not hinder general availability of this new feature. Exposure through
nightly builds should help us gather more usage data to assess whether there are
any more noteworthy implications we have not been aware of.

### Multi-Threading

The new implementation works well with the multi-threading preview
(`-Dpreview_mt`), having one event loop instance per thread.


There is one caveat though: file descriptors can only be owned by a single
event loop instance _at a time_. A file descriptor _can be moved_ from one
fiber to another, possibly moving from one event loop instance to another
along the way (transparently), but this is only possible if there are no
pending operations on that file descriptor.

For example: Let's assume fiber `A` running on thread `X` waits on file
descriptor `4`. While this operation is still pending, fiber `B` running on
thread `Y` tries to start another operation on file descriptor `4`. This is now
going to raise.

This limitation will be mitigated with the arrival of execution contexts from
[RFC #0002] which share one event loop instance between all threads in a
context.

### Timers and Timeouts

At this point, there's a missing optimization for timers (`sleep 1.second`) and
timeouts (`socket.read_timeout = 1.second`). In case you're using lots of them,
it might lead to performance degradation.

This is only a temporary limitation until we finish the implementation of an
efficient data structure. We're already working on that.

> **THANKS:**
>
> This feature is part of [the ongoing effort to improve multi threading in
> Crystal](/2024/02/09/84codes-manas-mt/) sponsored by
> [84codes](https://www.84codes.com/).
>
> Thanks for supporting the language and letting it shine!

[#14996]: https://github.com/crystal-lang/crystal/pull/14996
[availability]: https://github.com/crystal-lang/rfcs/blob/main/text/0009-lifetime-event_loop.md#availability
[RFC #0002]: https://github.com/crystal-lang/rfcs/pull/2
[RFC #0009]: https://github.com/crystal-lang/rfcs/blob/main/text/0009-lifetime-event_loop.md
