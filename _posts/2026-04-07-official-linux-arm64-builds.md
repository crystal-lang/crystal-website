---
title: "Official Linux ARM64 builds"
summary: "Finally, starting with Crystal 1.19 we provide official ARM64 builds"
author: ysbaddaden
categories: project
tags: [packaging]
---

This has been a long awaited feature: how to run Crystal on ARM64 CPUs?

Crystal has supported ARM64 as a tier 1 architecture for many years now, and
even provides an universal build for macOS, but still no ARM64 builds for Linux.

The wait is now over. During the development of Crystal 1.19 we bootstrapped a
1.18.2 compiler for ARM64 that was then used to bootstrap official builds for
nightlies and the 1.19 release.

The builds are available everywhere we provide an AMD64 build of the compiler
for Linux: nightly builds, [release tarballs], [Docker images], [Snap], as well
as the [install-crystal] GitHub action — just select an ubuntu arm runner.

[release tarballs]: https://github.com/crystal-lang/crystal/releases
[Docker images]: https://hub.docker.com/r/crystallang/crystal
[Snap]: https://snapcraft.io/crystal
[install-crystal]: https://github.com/crystal-lang/install-crystal/
