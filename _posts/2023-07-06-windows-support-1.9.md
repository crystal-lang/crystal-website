---
title: "Windows support in Crystal 1.9"
author: HertzDevil
summary: GUI installer, load-time dynamic linking support, and more
categories: technical
tags: [feature, windows, linking]
---

With the [release of Crystal 1.9](/2023/07/11/1.9.0-released), the compiler and the standard library have made a big step towards tier 1 support for x64 Windows with the MSVC toolchain. While an official Windows release isn't ready yet, only few outstanding issues remain and we expect them to be resolved in the following months. This post is a brief overview of what [1.9 has achieved](https://github.com/crystal-lang/crystal/pulls?q=is%3Apr+milestone%3A1.9.0+is%3Aclosed+label%3Aplatform%3Awindows) and what else needs to be achieved.

## GUI Installer

![installer](/assets/blog/2023-07-06-windows-installer.png)

For the first time, there is a GUI installer for Windows! It installs the compiler and all the third-party dependencies for the standard library. It also adds the compiler to the `PATH` environment variable, sets up file association, updates or uninstalls properly, and warns the user if the Windows SDK or Microsoft Visual Studio cannot be detected. This setup is expected to "just" work on new machines apart from installing those Microsoft components. It provides a more streamlined experience to Crystal users on Windows who are less familiar with command-line environments.

The upcoming 1.9 release will come with a download option for this GUI installer. A new installer will be built on GitHub Actions whenever a minor or patch release is available, so you normally won't see installers for nightly builds like the screenshot above, although updating to or from a nightly version shouldn't be any different. If you have a GitHub account, please take a try at the ~~[`crystal-installer` artifact from this CI run](https://github.com/crystal-lang/crystal/actions/runs/5435802346)~~ and report any issues you found. You could also try building the installer locally, using Inno Setup and following the Windows workflow instructions.

## Dynamic linking

Much of the work in the past three months went into supporting load-time dynamic linking on Windows as seamlessly as possible. You can now use the `-Dpreview_dll` compile-time flag to opt in to experimental dynamic linking support. More details can be found in the reference manual ([1.9](https://crystal-lang.org/reference/1.9/guides/static_linking.html), [master](https://crystal-lang.org/reference/master/guides/static_linking.html)). A brief summary is:

- `@[Link("foo")]` will now instruct the compiler to search for `foo-static.lib` before `foo.lib` when linking statically, or `foo-dynamic.lib` before `foo.lib` when linking dynamically, allowing both libraries to be served side-by-side in the same directory.
- Static linking implies `/MT` and dynamic linking implies `/MD`. Your own C libraries should be built with the appropriate MSVC linker flags.
- If the compiler flag `-Dpreview_win32_delay_load` is supplied, the `CRYSTAL_LIBRARY_RPATH` build-time environment variable can be used to prepend DLL search paths to the default search order. It is inspired by `DT_RPATH` for ELF binaries, and likewise supports `$ORIGIN`, enabling relocatable, dynamically linked Windows binaries.

Static linking will remain the default linking mode for Windows on Crystal 1.9 and 1.10; the compiler flag `-Dpreview_dll` enables dynamic linking in these versions. Afterwards, dynamic linking will become the default and `--static` will be required for static linking, just like on other systems. Please add `--static` to your build scripts appropriately if they rely on that.

## Other notable advancements

- `IO.pipe` is now asynchronous ([#13362](https://github.com/crystal-lang/crystal/pull/13362)). This enables concurrency in a few crucial features on Windows, most notably piping a `Process`'s streams to `IO`s, and async `Log` backends. Note that `File`s and standard streams like `STDOUT` are still synchronous at the moment.
- `timeout` now works correctly inside `select` expressions ([#13525](https://github.com/crystal-lang/crystal/pull/13525)).
- `Time::Location` now respects IANA time zone names out of the box ([#13517](https://github.com/crystal-lang/crystal/pull/13517)), and local time zones without daylight saving time transitions ([#13516](https://github.com/crystal-lang/crystal/pull/13516)).
- `STDIN`, `STDOUT`, and `STDERR` are now opened in binary mode, rather than text mode ([#13397](https://github.com/crystal-lang/crystal/pull/13397)). This is necessary for the macro `run` to work with certain source files that contain CRLF line endings.
- Unix sockets are now supported to the extent that Windows actually implements ([#13493](https://github.com/crystal-lang/crystal/pull/13493)), as well as several other miscellaneous socket APIs ([#13325](https://github.com/crystal-lang/crystal/pull/13325), [#13326](https://github.com/crystal-lang/crystal/pull/13326), [#13363](https://github.com/crystal-lang/crystal/pull/13363), [#13364](https://github.com/crystal-lang/crystal/pull/13364)).
- Read-only files and directories can now be deleted properly ([#13462](https://github.com/crystal-lang/crystal/pull/13462), [#13626](https://github.com/crystal-lang/crystal/pull/13626)).

## What's left

An ever-changing list of outstanding issues on Windows can be found in [this GitHub project](https://github.com/orgs/crystal-lang/projects/11), and we hope to squash the "Todo" and "In progress" columns by the time an official Windows release is available. As of the time of writing this post, the main remaining issues are:

- Behavior of `Process.new(shell: true)` ([#9030](https://github.com/crystal-lang/crystal/issues/9030))
- Support for long paths in file APIs ([#13420](https://github.com/crystal-lang/crystal/issues/13420))
- Platform-independent `sprintf` for floats ([#12473](https://github.com/crystal-lang/crystal/pull/12473))
- Making `/SUBSYSTEM:WINDOWS` more usable ([#13058](https://github.com/crystal-lang/crystal/issues/13058), [#13330](https://github.com/crystal-lang/crystal/issues/13330))
- `Process#close` inside `Process.run` ([#13425](https://github.com/crystal-lang/crystal/issues/13425))
- `crystal play` ([#13492](https://github.com/crystal-lang/crystal/issues/13492)) and `crystal i` ([#12396](https://github.com/crystal-lang/crystal/issues/12396))
- Channels do not behave correctly under `-Dpreview_mt`

The number of specs in the standard library test suite tagged with `pending_win32` has dropped from 35 to 8 since the previous minor release. This is a sign of rapid progress, and this progress shall be carried over into the next development cycle.
