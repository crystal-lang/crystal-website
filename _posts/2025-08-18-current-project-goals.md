---
title: "Current project goals"
summary: "An overview of active and future efforts in the project"
author: mverzilli
categories: project
tags: [project, sponsors]
---

In this post, we share a summary of current active efforts by the Crystal core team and the community. We also share whether these efforts are being funded and to what extent (to the best of our knowledge anyway!). We hope by doing this we can motivate more people to contribute, be it through work or funding :-). The list is by no means exhaustive: we want to provide a bird's eye view of the main current drivers of the project. There's much, much more work being done by the community at large and the core team to keep the Crystal train chugging along.

<details>
<summary><strong>Goal summary</strong></summary>
🧪 Research => 🔵 In Progress => ✅ Completed
<ul>
  <li>🔵 <a href="#windows-support">Windows Support</a></li>
  <li>🔵 <a href="#multi-threading">Multi-threading</a>
    <ul>
      <li>🔵 <a href="#execution-contexts">Execution contexts</a></li>
      <li>🧪 <a href="#stdlib-thread-safety">Stdlib thread-safety</a></li>
      <li>🧪 <a href="#generated-code-thread-safety">Generated code thread-safety</a></li>
      <li>🧪 <a href="#io-buffer-thread-safety">IO buffer thread-safety</a></li>
    </ul>
  </li>
  <li><a href="#event-loop">Event Loop</a>
    <ul>
      <li>✅ <a href="#event-loop-refactor">Event Loop Refactor</a></li>
      <li>🔵 <a href="#event-loop-on-io_uring">Event loop on io_uring</a></li>
    </ul>
  </li>
  <li>🧪 <a href="#fiber-local-storage">Fiber local storage</a></li>
  <li>🧪 <a href="#structured-concurrency">Structured Concurrency</a></li>
  <li>🧪 <a href="#simd">SIMD</a></li>
</ul>
</details>

If you want to see any of these goals _crystallize_ faster please consider engaging the linked conversations, sponsoring one of these projects, or donating to the project in general at [OpenCollective](https://opencollective.com/crystal-lang). Every penny we get translates directly into extra brain cycles spent on Crystal 🚀.

## Windows Support

Windows support has historically been one of the most requested features in Crystal. The reality is that you can to a great extent use Crystal on Windows **today**, but there are still some rough edges and missing features that prevent us from putting the [tier 1](https://crystal-lang.org/reference/1.17/syntax_and_semantics/platform_support.html#tier-1) stamp on it just yet. It's been a long journey but we are now really, really close!

Status
: 🔵 In Progress, led by [@HertzDevil](https://github.com/HertzDevil)

Sponsored by
: [Funding status at
OpenCollective](https://opencollective.com/crystal-lang/projects/windows-support)

Start Date
: September 2013

Learn more
: - [Project board](https://github.com/orgs/crystal-lang/projects/11/views/5)
- [Original issue](https://github.com/crystal-lang/crystal/issues/26)

Milestones
: - 2023-04-24: All main platform features are finished. There are still smaller issues left.
- 2021-11-18: The compiler and most of the stdlib work on Windows.

## Multi-threading

We want Crystal to have a world class runtime, supporting multi-threading in a way that is efficient, easy to use and safe. Thanks to 84codes' continued sponsorship of this goal, it is also very close to being achieved. Let's see a list of the main current efforts in this area.

Status
: 🔵 In Progress, led by [@ysbaddaden](https://github.com/ysbaddaden)

Sponsored by
: [84codes](https://84.codes/)

Start date
: December 2023

Learn more
: [Charting the route to MT support](https://forum.crystal-lang.org/t/charting-the-route-to-multi-threading-support/7320)

### Execution contexts

At the center of the multi-threading epic lies the design and implementation of _execution contexts_. An execution context creates and manages a dedicated pool of one or more threads where fibers can be executed into. Each context manages the rules to run, suspend and swap fibers internally. Execution contexts give developers greater control over how fibers are orchestrated and picked up by threads, resulting in more predictable and customizable runtime behavior.

Status
: 🔵 In Progress, led by [@ysbaddaden](https://github.com/ysbaddaden)

Sponsored by
: [84codes](https://84.codes/)

Start date
: December 2023

Learn more
: - [RFC #2: MT Execution Contexts](https://github.com/crystal-lang/rfcs/blob/main/text/0002-execution-contexts.md)
- [Epic Issue](https://github.com/crystal-lang/crystal/issues/15342)

### Stdlib thread-safety

The standard library predates even the earliest experimental work on multi-threading. With the advent of a more powerful multi-threading runtime, we are in the process of reviewing the whole stdlib from the perspective of thread safety. In some cases this will imply reworking some code to provide thread-safe guarantees, but in all cases we need to document whether a given construct is thread-safe or not.

Status
: 🧪 Research

Learn more
: [Safety guarantees of stdlib data structures](https://forum.crystal-lang.org/t/safety-guarantees-of-stdlib-data-structures/7364)

### Generated code thread-safety

Similar to the standard library, the compiler can generate code with potential thread-safety problems. We are reviewing the compiler codebase to surface those issues.

Status
: 🧪 Research

Learn more
: [Thread-safety for union types](https://github.com/crystal-lang/crystal/issues/15085)

### IO buffer thread-safety

There are some concrete issues with how Crystal manages IO buffers in a multi-threaded environment. We need to work on making IO buffering thread-safe, and flushing buffers consistently without extreme delays.

Status
: 🧪 Research

Learn more
: - [IO can be duplicated in MT](https://github.com/crystal-lang/crystal/issues/8438)
- [puts in a multi-threaded environment](https://github.com/crystal-lang/crystal/issues/8140#top)
- [Flush file output on program exit](https://github.com/crystal-lang/crystal/issues/13995)

## Event loop

Crystal's evented IO loop has also been getting a lot of love, in part motivated by the multi-threading work.

### Event loop refactor

The original event loop API in Crystal was directly influenced by its underlying implementation based on `libevent`. This was limiting, as different platforms present different constraints. Additionally, with the multi-threading project in the horizon, we found ourselves in need of more flexibility and efficiency. So we set out to refactor Crystal's event loop API. This project is now complete, we have a generic API and multiple implementations: IOCP for Windows, io_uring for Linux (see above), and even the legacy `libevent` based one.

Status
: ✅ Completed, led by [@ysbaddaden](https://github.com/ysbaddaden)

Sponsored by
: [84codes](https://84.codes/)

Start date
: May 2023

Released
: Crystal 1.15 (January 2025)

Learn more
: - [RFC #7: Event Loop Refactor](https://github.com/crystal-lang/rfcs/blob/main/text/0007-event_loop-refactor.md)
- [RFC #9: Lifetime Event Loop](https://github.com/crystal-lang/rfcs/blob/main/text/0009-lifetime-event_loop.md)
- [Announcement blogpost](https://crystal-lang.org/2024/11/05/lifetime-event-loop/)

### Event loop on io_uring

Linux 5.1 brought us _io_uring_, a new interface that makes it possible to run asynchronous IO with zero (or very few) system calls. It works by keeping a lock-free IO submission queue and a lock-free IO completion queue in a memory shared between the kernel and the application (thus reducing context switches). The performance improvements are impressive. Now that Crystal has a revamped event loop explicitly designed to swap underlying implementations, the time is ripe to experiment with an _io_uring_ backed event loop.

Status
: 🔵 In Progress, led by [@ysbaddaden](https://github.com/ysbaddaden)

Sponsored by
: [84codes](https://84.codes/)

Start date
: April 2025

Learn more
: - [Original issue](https://github.com/crystal-lang/crystal/issues/10740)
- [Epic issue](https://github.com/crystal-lang/crystal/pull/15634)


## Fiber local storage

We are analyzing structured approaches to storing data in the context of a fiber.

Status
: 🧪 Research

Learn more
: - [Proof of concept](https://github.com/crystal-lang/crystal/pull/15889)
- [Field study](https://forum.crystal-lang.org/t/field-study-of-fiber-local-storage/8325)

## Structured Concurrency

With a solid concurrency model based on fibers and channels, and with the multi-threading runtime getting close to being enabled by default, we can start looking into higher level concurrency abstractions. The idea of structured concurrency is to ensure that fibers have lifetimes nested within program scopes, which should make it easier to reason about them, guarantee that they are properly and timely disposed of, etc.

Status
: 🧪 Research

Learn more
: [Original issue](https://github.com/crystal-lang/crystal/issues/6468)

## SIMD

Support Single Instruction Multiple Data in the language and standard library.

Status
: 🧪 Research

Learn more
: [Original issue](https://github.com/crystal-lang/crystal/issues/3057)
