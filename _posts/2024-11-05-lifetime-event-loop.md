---
title: "Lifetime Event Loop"
author: straight-shoota,ysbaddaden
summary: ""
categories: technical
tags: [feature, eventloop, concurrency]
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

In case of performance regression or other issues, you can switch
back to the legacy event loop implementation with the compile-time flag
`-Deventloop=libevent`.

Dropping `libevent` removes an external runtime dependency from Crystal
programs.

## Caveats

In some cases the new implementation may cause issues. If you're affected,
we recommend falling back to `libevent` with `-Deventloop=libevent`.

We are aware of some scenarios but believe they are quite rare and should not
hinder general availability of this new feature. Exposure through nightly builds
should help us gather more usage data to assess whether there are any more
noteworthy implications we have not been aware of.

### Timers and Timeouts

At this point, there's a missing optimization for timers (`sleep 1.second`) and
timeouts (`socket.read_timeout = 1.second`). In case you're using lots of them,
it might lead to performance degradation.

This is only a temporary limitation until we finish the implementation of an
efficient data structure. We're already working on that.

### Multi-Threading

The new implementation works well with the multi-threading preview
(`-Dpreview_mt`), having one event loop instance per thread.

There is on caveat though: Moving file descriptors with pending operations
between event loop instances – i.e. between threads – is an error.

For example: Let's assume fiber `A` running on thread `X` waits on file
descriptor `4`. While this operation is still pending, fiber `B` running on
thread `Y` tries to start another operation on file descriptor `4`. This is now
going to raise. File descriptors can only be owned by a single event loop
instance.

This limitation will be mitigated with the arrival of execution contexts from
[RFC #0002] which share one event loop instance between all threads in a
context.

[#14996]: https://github.com/crystal-lang/crystal/pull/14996
[availability]: https://github.com/crystal-lang/rfcs/blob/rfc/lifetime-event_loop/text/0009-lifetime-event_loop.md#availability
[RFC #0002]: https://github.com/crystal-lang/rfcs/pull/2
[RFC #0009]: https://github.com/crystal-lang/rfcs/pull/9
