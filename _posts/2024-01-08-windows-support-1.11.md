---
title: "Windows support in Crystal 1.11"
author: HertzDevil
summary: Playground, preliminary interpreter support, and better dynamic linking
---

It has been 6 months since we last reported on the [status of Windows support in Crystal 1.9](/2023/07/06/windows-support-1.9). Although there aren't as many changes in [1.10](https://github.com/crystal-lang/crystal/pulls?q=is%3Apr+milestone%3A1.10.0+is%3Aclosed+label%3Aplatform%3Awindows) and [1.11](https://github.com/crystal-lang/crystal/pulls?q=is%3Apr+milestone%3A1.11.0+is%3Aclosed+label%3Aplatform%3Awindows), we have nonetheless made some significant breakthroughs which will be described below.

## Playground support

The playground now works on Windows. For a long time, `Process#wait` was synchronous on Windows, which means other fibers would not get the chance to run until the process exits. The playground server communicates with the compiled program via multiple WebSocket messages, and a synchronous `Process#wait` would effectively block the server. This is no longer the case since [#13908], and you will be able to use `crystal play` just like on other systems.

## Finishing DLL coverage

Currently, the compiler is statically linked for two reasons: the C function `LibC.snprintf` is not available in the C runtime DLLs, and the compiler depends on LLVM's C++ API, which requires a static LLVM build tree.

The main remaining use of `LibC.snprintf` was implementing the floating-point format specifiers for Crystal's `sprintf` and `String#%`, such as `%.2f` and `%g`. By porting the Ryu Printf algorithm to native Crystal ([#14067], [#14084], [#14102], [#14123], [#14132]), this dependency is now gone from Windows and Unix-like systems, with the added benefit that float printing is unaffected by the active C locale.

There is nothing Crystal could do if the used LLVM version does not expose all the needed functionality via LLVM's C API, so instead the Crystal team now upstreams those necessary APIs to LLVM itself. After [#14082] and [#14101], the `LLVM-C.dll` library from LLVM 18 or above plus a small configuration file is sufficient; the compiler will eventually become dynamically linked, and still be able to rebuild itself without an LLVM build tree.

## `dll` parameter for `@[Link]`

Crystal originally used a technique called DLL delay-loading to load DLLs from non-default locations, but it was revealed that not all DLLs work that way, so Crystal is now trying a different strategy to simplify dynamic builds. The `@[Link]` annotation now accepts a `dll` parameter which lets you specify non-system DLL dependencies: ([#14131])

```crystal
@[Link("z", dll: "zlib1.dll")]
lib LibYAML
end
```

The compiler will look up the DLLs in a set of search paths, and copy them to the same directory as the built program, including the temporary executables built for commands like `crystal run`. Refer to the [documentation](https://crystal-lang.org/api/1.11.0/Link.html) for more details.

## Interpreter support

With everything combined, the interpreter will now more or less run on Windows. There are still some rough edges pending resolution before the interpreter is released on Windows, but you could try rebuilding the compiler itself to see the REPL session in action.

## What's left

As before, the list of outstanding issues on Windows can be found in [this GitHub project](https://github.com/orgs/crystal-lang/projects/11), and we hope to squash the "Todo" and "In progress" columns by the time an official Windows release is available. The main remaining issues, in order of importance, are:

* Finalizing the details for dynamic linking ([#11575])
* `crystal i` ([#12396])
* Behavior of `Process.new(shell: true)` ([#9030])
* Channels do not behave correctly under `-Dpreview_mt` ([#14222])
* Support for case-insensitive `Dir.glob` ([#13510])
* Support for long paths in file APIs ([#13420])
* Making `/SUBSYSTEM:WINDOWS` more usable ([#13330])

Regarding dynamic linking, if everything goes as intended, a future Crystal version will make the following **breaking changes**:

* The compiler itself will be dynamically linked, as described above, once LLVM 18 is generally available.
* All builds will assume dynamic linking by default; `-Dpreview_dll` will have no effect, and `--static` becomes mandatory to preserve the current behavior.
* The delay-load helper and `Crystal::LIBRARY_RPATH` will be removed.

[#9030]: https://github.com/crystal-lang/crystal/pull/9030
[#11575]: https://github.com/crystal-lang/crystal/pull/11575
[#12396]: https://github.com/crystal-lang/crystal/pull/12396
[#13330]: https://github.com/crystal-lang/crystal/pull/13330
[#13420]: https://github.com/crystal-lang/crystal/pull/13420
[#13510]: https://github.com/crystal-lang/crystal/pull/13510
[#13908]: https://github.com/crystal-lang/crystal/pull/13908
[#14067]: https://github.com/crystal-lang/crystal/pull/14067
[#14082]: https://github.com/crystal-lang/crystal/pull/14082
[#14084]: https://github.com/crystal-lang/crystal/pull/14084
[#14101]: https://github.com/crystal-lang/crystal/pull/14101
[#14102]: https://github.com/crystal-lang/crystal/pull/14102
[#14123]: https://github.com/crystal-lang/crystal/pull/14123
[#14131]: https://github.com/crystal-lang/crystal/pull/14131
[#14132]: https://github.com/crystal-lang/crystal/pull/14132
[#14222]: https://github.com/crystal-lang/crystal/pull/14222
