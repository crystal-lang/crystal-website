---
title: Alpine-based Docker images
summary: Using Crystal with brand new Docker images based on Alpine Linux
author: straight-shoota
---


The Crystal team provides Docker images with installed Crystal compiler on Docker Hub at [`crystallang/crystal`](https://hub.docker.com/r/crystallang/crystal/). Crystal versions since 0.13.0 are available as Docker images based on different versions of [Ubuntu Linux](https://ubuntu.org/).
Images based on [Alpine Linux](https://alpinelinux.org/) are now also vailable, starting with [0.32.1-alpine](https://hub.docker.com/layers/crystallang/crystal/0.32.1-alpine/images/sha256-8f66a0a36a7e7c396944f64c89fa81a3b488ca6c82ce55ca5d5f1edd348d14e6).
Alpine images are a bit more lightweight than Ubuntu images, for 0.32.1 it's 185 MB vs. 115 MB. A few bytes saved.

But more importantly, Alpine Linux is based on [`musl-libc`](https://www.musl-libc.org/) instead of [`gnu-libc`](https://www.gnu.org/software/libc/) which is used by default on most other distributions, including Ubuntu. Linking against `musl-libc` is currently the only way to [build fully statically linked Crystal binaries](https://github.com/crystal-lang/crystal/wiki/Static-Linking).
Alpine Linux makes this easy enough. For example, the offical Crystal compiler builds for Linux are statically linked against `musl-libc` on Alpine Linux.

[Crystal packages for APK (Alpine's package manager)](https://pkgs.alpinelinux.org/package/edge/community/x86_64/crystal) have been available for quite some time and the edge releases are usually updated pretty quickly. Updated Docker images are going to be available immediately on a new Crystal release. And they're always based on a stable version of Alpine Linux but provide the latest Crystal release.

Here's an example how the Docker image can be used to build a statically linked *Hello World* program:

```terminal
$ echo 'puts "Hello World!"' > hello-world.cr
$ docker run --rm -it -v $PWD:/workspace -w /workspace crystallang/crystal:0.32.1-alpine \
    crystal build hello-world.cr --static
$ ./hello-world
Hello World!
$ ldd hello-world
        statically linked
```
