---
subtitle: On Termux
---

[Termux](https://termux.dev/en/) is a terminal emulator and Linux command line
environment on Android that does not require a rooted device to run. Programs
under Termux are linked against the Android OS's Bionic C runtime library.

Currently only `aarch64` builds are available.

## Install

Crystal 1.9 or above is available on Termux's [official package repository](https://packages.termux.dev/):

`pkg install crystal`

The Termux repository only hosts the latest versions of its packages, including
LLVM, which Crystal depends on. Crystal releases may fall behind if they do not
support the most recent LLVM version.

## Upgrade

When a new Crystal version is released you can upgrade your system using:

`pkg upgrade`

## Uninstall

To remove Crystal on Termux:

`pkg uninstall crystal`
