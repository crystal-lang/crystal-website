---
subtitle: From sources
---

If you want to contribute then you might want to install Crystal from sources.

1. [Install the latest Crystal release](/install). To compile Crystal, you need Crystal :).

2. Make sure a supported LLVM version is present in the path. When possible, use the latest supported version: 8.0.

3. Make sure to install [all the required libraries](https://github.com/crystal-lang/crystal/wiki/All-required-libraries). You might also want to read the [contributing guide](https://github.com/crystal-lang/crystal/blob/master/CONTRIBUTING.md).

4. Clone the repository: `git clone https://github.com/crystal-lang/crystal`

5. Run `make` to build your own version of the compiler.

6. Run `make std_spec compiler_spec` to ensure all specs pass, and you've installed everything correctly.

7. Use `bin/crystal` to run your crystal files.

If you would like more information about `bin/crystal`, check out the [using the compiler](https://crystal-lang.org/reference/using_the_compiler/) documentation.

Note: The actual binary is built in to `.build/crystal`, but the `bin/crystal` wrapper script is what you should use to run crystal.
