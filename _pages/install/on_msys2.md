---
title: MSYS2 (Preview)
page_title: Install on MSYS2 (Preview)
---

[MSYS2](https://www.msys2.org/) is a native build environment on Windows that
provides Bash, POSIX tools, multiple GCC and Clang toolchains, and a
Pacman-based package repository for both applications and development libraries.

**Be aware that Crystal on Windows is** [**not yet complete**](https://github.com/crystal-lang/crystal/issues/5430).

## Install

MSYS2 comes in multiple [environments](https://www.msys2.org/docs/environments/)
which determine the active toolchain and C/C++ runtime libraries. Crystal is
currently available for the UCRT64, CLANG64, and MINGW64 environments. To
install or upgrade Crystal for one of the environments:

```bash
pacman -Sy mingw-w64-ucrt-x86_64-crystal  # UCRT64 environment
pacman -Sy mingw-w64-clang-x86_64-crystal # CLANG64 environment
pacman -Sy mingw-w64-x86_64-crystal       # MINGW64 environment
```

Shards can be installed or upgraded similarly:

```bash
pacman -Sy mingw-w64-ucrt-x86_64-shards # ditto for other environments
```

The [Pactoys](https://packages.msys2.org/packages/pactoys) package can simplify
the installation process by not having to supply the full environment prefix; it
provides `pacboy`, a Pacman wrapper that automatically infers this prefix from
the currently active environment. To install Crystal and Shards this way:

```bash
pacman -Sy pactoys
pacboy -S crystal shards
```

## Uninstall

To remove Crystal on MSYS2:

```bash
pacman -R mingw-w64-ucrt-x86_64-crystal # ditto for other environments
```
