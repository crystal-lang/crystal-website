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
      <li>🧪 <a href="#fiber-local-storage">Fiber local storage</a></li>
      <li>🧪 <a href="#stdlib-thread-safety">Stdlib thread-safety</a></li>
      <li>🧪 <a href="#compiler-thread-safety">Compiler thread-safety</a></li>
      <li>🧪 <a href="#io-buffer-thread-safety">IO buffer thread-safety</a></li>
    </ul>
  </li>
  <li><a href="#event-loop">Event Loop</a>
    <ul>
      <li>✅ <a href="#event-loop-refactor">Event Loop Refactor</a></li>
      <li>🔵 <a href="#event-loop-on-io_uring">Event loop on io_uring</a></li>
    </ul>
  </li>
  <li>🧪 <a href="#structured-concurrency">Structured Concurrency</a></li>
  <li>🧪 <a href="#simd">SIMD</a></li>
</ul>
</details>

If you want to see any of these goals _crystallize_ faster please consider engaging the linked conversations, sponsoring one of these projects, or donating to the project in general at [OpenCollective](https://opencollective.com/crystal-lang). Every penny we get translates directly into extra brain cycles spent on Crystal 🚀.

## Windows Support

Windows support has historically been one of the most requested features in Crystal. The reality is that you can to a great extent use Crystal on Windows **today**, but there are still some rough edges and missing features that prevent us from putting the [tier 1](https://crystal-lang.org/reference/1.17/syntax_and_semantics/platform_support.html#tier-1) stamp on it just yet. It's been a long journey but we are now really, really close!

<table class="properties">
<tbody>
  <tr>
    <th scope="row">
      Status
    </th>
    <td>
      🔵 In Progress, led by <a href="https://github.com/HertzDevil">@HertzDevil</a></td>
  </tr>
  <tr>
    <th scope="row">
      Sponsored by
    </th>
    <td>
      Next to zero contributions at the moment. <a href="https://opencollective.com/crystal-lang/projects/windows-support">Funding status at OpenCollective.</a>
    </td>
  </tr>
  <tr>
    <th scope="row">
      Start date
    </th>
    <td>
      September 2013
    </td>
  </tr>
  <tr>
    <th scope="row">
      Learn more
    </th>
    <td>
      <a href="https://github.com/orgs/crystal-lang/projects/11/views/5">Project board</a>,
      <a href="https://github.com/crystal-lang/crystal/issues/26">Original issue</a>
    </td>
  </tr>
</tbody>
</table>

**Latest milestones**:

- 2023-04-24: All main platform features are finished. There are still smaller issues left.
- 2021-11-18: The compiler and most of the stdlib work on Windows.

## Multi-threading

We want Crystal to have a world class runtime, supporting multi-threading in a way that is efficient, easy to use and safe. Thanks to 84codes' continued sponsorship of this goal, it is also very close to being achieved. Let's see a list of the main current efforts in this area. For a more detailed overview of direction, status and the quests derived from these goals, please refer to [Charting the route to multi-threading support](https://forum.crystal-lang.org/t/charting-the-route-to-multi-threading-support/7320).

<table class="properties">
<tbody>
  <tr>
    <th scope="row">
      Status
    </th>
    <td>
      🔵 In Progress, led by <a href="https://github.com/ysbaddaden">@ysbaddaden</a>
    </td>
  </tr>
  <tr>
    <th scope="row">
      Sponsored by
    </th>
    <td>
      <a href="https://84.codes/">84codes</a>
    </td>
  </tr>
  <tr>
    <th scope="row">
      Start date
    </th>
    <td>
      December 2023
    </td>
  </tr>
  <tr>
    <th scope="row">
      Learn more
    </th>
    <td>
      <a href="https://forum.crystal-lang.org/t/charting-the-route-to-multi-threading-support/7320">Charting the route to MT support</a>
    </td>
  </tr>
</tbody>
</table>

### Execution contexts

At the center of the multi-threading epic lies the design and implementation of _execution contexts_. An execution context creates and manages a dedicated pool of one or more threads where fibers can be executed into. Each context manages the rules to run, suspend and swap fibers internally. Execution contexts give developers greater control over how fibers are orchestrated and picked up by threads, resulting in more predictable and customizable runtime behavior. If you want to delve deeper, please check out [Crystal's RFC #2](https://github.com/crystal-lang/rfcs/blob/main/text/0002-execution-contexts.md).

<table class="properties">
<tbody>
  <tr>
    <th scope="row">
      Status
    </th>
    <td>
      🔵 In Progress, led by <a href="https://github.com/ysbaddaden">@ysbaddaden</a>
    </td>
  </tr>
  <tr>
    <th scope="row">
      Sponsored by
    </th>
    <td>
      <a href="https://84.codes/">84codes</a>
    </td>
  </tr>
  <tr>
    <th scope="row">
      Start date
    </th>
    <td>
      December 2023
    </td>
  </tr>
  <tr>
    <th scope="row">
      Learn more
    </th>
    <td>
      <a href="https://github.com/crystal-lang/rfcs/blob/main/text/0002-execution-contexts.md">RFC</a>,
      <a href="https://github.com/crystal-lang/crystal/issues/15342">Epic Issue</a>
    </td>
  </tr>
</tbody>
</table>

### Fiber local storage

We are analyzing structured approaches to storing data in the context of a fiber.

<table class="properties">
<tbody>
  <tr>
    <th scope="row">
      Status
    </th>
    <td>
      🧪 Research
    </td>
  </tr>
  <tr>
    <th scope="row">
      Learn more
    </th>
    <td>
      <a href="https://github.com/crystal-lang/crystal/pull/15889">Proof of concept</a>,
      <a href="https://forum.crystal-lang.org/t/field-study-of-fiber-local-storage/8325">Field study</a>
    </td>
  </tr>
</tbody>
</table>

### Stdlib thread-safety

The standard library predates even the earliest experimental work on multi-threading. With the advent of a more powerful multi-threading runtime, we are in the process of reviewing the whole stdlib from the perspective of thread safety. In some cases this will imply reworking some code to provide thread-safe guarantees, but in all cases we need to document whether a given construct is thread-safe or not.

<table class="properties">
<tbody>
  <tr>
    <th scope="row">
      Status
    </th>
    <td>
      🧪 Research
    </td>
  </tr>
  <tr>
    <th scope="row">
      Learn more
    </th>
    <td>
      <a href="https://forum.crystal-lang.org/t/safety-guarantees-of-stdlib-data-structures/7364">Safety guarantees of stdlib data structures</a>
    </td>
  </tr>
</tbody>
</table>

### Compiler thread-safety

Similar to the standard library, there are parts of the compiler with potential thread-safety problems. We are reviewing the compiler to surface those issues.

<table class="properties">
<tbody>
  <tr>
    <th scope="row">
      Status
    </th>
    <td>
      🧪 Research
    </td>
  </tr>
  <tr>
    <th scope="row">
      Learn more
    </th>
    <td>
      <a href="https://github.com/crystal-lang/crystal/issues/15085">Thread-safety for union types</a>
    </td>
  </tr>
</tbody>
</table>

### IO buffer thread-safety

There are some concrete issues with how Crystal manages IO buffers in a multi-threaded environment. We need to work on making IO buffering thread-safe, and flushing buffers consistently without extreme delays.

<table class="properties">
<tbody>
  <tr>
    <th scope="row">
      Status
    </th>
    <td>
      🧪 Research
    </td>
  </tr>
  <tr>
    <th scope="row">
      Learn more
    </th>
    <td>
      <a href="https://github.com/crystal-lang/crystal/issues/8438">IO can be duplicated in MT</a><br/><a href="https://github.com/crystal-lang/crystal/issues/8140#top">puts in a multi-threaded environment</a><br/><a href="https://github.com/crystal-lang/crystal/issues/13995">Flush file output on program exit</a>
    </td>
  </tr>
</tbody>
</table>

## Event loop

Crystal's evented IO loop has also been getting a lot of love, in part motivated by the multi-threading work.

### Event loop Refactor

The original event loop API in Crystal was directly influenced by its underlying implementation based on `libevent`. This was limiting, as different platforms present different constraints. Additionally, with the multi-threading project in the horizon, we found ourselves in need of more flexibility and efficiency. So we set out to refactor Crystal's event loop API. This project is now complete, we have a generic API and multiple implementations: IOCP for Windows, io_uring for Linux (see above), and even the legacy `libevent` based one.

<table class="properties">
<tbody>
  <tr>
    <th scope="row">
      Status
    </th>
    <td>
      ✅ Completed, led by <a href="https://github.com/ysbaddaden">@ysbaddaden</a>
    </td>
  </tr>
  <tr>
    <th scope="row">
      Sponsored by
    </th>
    <td>
      <a href="https://84.codes/">84codes</a>
    </td>
  </tr>
  <tr>
    <th scope="row">
      Start date
    </th>
    <td>
      May 2023
    </td>
  </tr>
  <tr>
    <th scope="row">
      Released
    </th>
    <td>
      Crystal 1.15 (January 2025)
    </td>
  </tr>
  <tr>
    <th scope="row">
      Learn more
    </th>
    <td>
      <a href="https://github.com/crystal-lang/rfcs/blob/main/text/0007-event_loop-refactor.md">RFC</a><br/><a href="https://github.com/crystal-lang/rfcs/blob/main/text/0009-lifetime-event_loop.md">Event loop lifetimes RFC</a><br/><a href="https://crystal-lang.org/2024/11/05/lifetime-event-loop/">Announcement blogpost</a>
    </td>
  </tr>
</tbody>
</table>

### Event loop on io_uring

Linux 5.1 brought us _io_uring_, a new interface that makes it possible to run asynchronous IO with zero (or very few) system calls. It works by keeping a lock-free IO submission queue and a lock-free IO completion queue in a memory shared between the kernel and the application (thus reducing context switches). The performance improvements are impressive. Now that Crystal has a revamped event loop explicitly designed to swap underlying implementations, the time is ripe to experiment with an _io_uring_ backed event loop.

<table class="properties">
<tbody>
  <tr>
    <th scope="row">
      Status
    </th>
    <td>
      🔵 In Progress, led by <a href="https://github.com/ysbaddaden">@ysbaddaden</a>
    </td>
  </tr>
  <tr>
    <th scope="row">
      Sponsored by
    </th>
    <td>
      <a href="https://84.codes/">84codes</a>
    </td>
  </tr>
  <tr>
    <th scope="row">
      Start date
    </th>
    <td>
      April 2025
    </td>
  </tr>
  <tr>
    <th scope="row">
      Learn more
    </th>
    <td>
      <a href="https://github.com/crystal-lang/crystal/issues/10740">Original issue</a>,
      <a href="https://github.com/crystal-lang/crystal/pull/15634">Epic issue</a>
    </td>
  </tr>
</tbody>
</table>

## Structured Concurrency

With a solid concurrency model based on fibers and channels, and with the multi-threading runtime getting close to being enabled by default, we can start looking into higher level concurrency abstractions. The idea of structured concurrency is to ensure that fibers have lifetimes nested within program scopes, which should make it easier to reason about them, guarantee that they are properly and timely disposed of, etc.

<table class="properties">
<tbody>
  <tr>
    <th scope="row">
      Status
    </th>
    <td>
      🧪 Research
    </td>
  </tr>
  <tr>
    <th scope="row">
      Learn more
    </th>
    <td>
      <a href="https://github.com/crystal-lang/crystal/issues/6468">RFC</a>
    </td>
  </tr>
</tbody>
</table>

## SIMD

Support Single Instruction Multiple Data in the language and standard library.

<table class="properties">
<tbody>
  <tr>
    <th scope="row">
      Status
    </th>
    <td>
      🧪 Research
    </td>
  </tr>
  <tr>
    <th scope="row">
      Learn more
    </th>
    <td>
      <a href="https://github.com/crystal-lang/crystal/issues/3057">Original issue</a>
    </td>
  </tr>
</tbody>
</table>
