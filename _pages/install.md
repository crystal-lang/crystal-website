---
title: Install
permalink: /install/
layout: page-wide
page_class: page--segmented
section: docs
description: |
  Crystal packages are available from different sources.
  There are official ones provided the Crystal project, system packages and
  community-maintained packages.
  This page gives an overview of available installation methods.
link_actions:
- '[![](/assets/install/linux.svg) #Linux](#linux)'
- '[![](/assets/install/apple.svg) #MacOS](#macos)'
- '[![](/assets/install/windows.svg) #Windows](#windows)'
- '[![](/assets/install/freebsd.svg) #FreeBSD](#freebsd)'
- '[![](/assets/install/openbsd.svg) #OpenBSD](#openbsd)'
- '[![](/assets/install/android.svg) #Android](#android)'
- '[![](/assets/install/docker.svg) #Docker](#docker)'
- '[![](/assets/install/construction.svg) #Tools](#developer-tools)'
- '[![](/assets/icons/build-circle.svg) Nightlies](/install/nightlies)'
- '[![](/assets/icons/source-branch.svg) Source](/install/from_sources)'
---
## Linux

Many Linux distribution have Crystal available in their system packages.
It might not have the most recent version though.
Third party package managers can be more up to date.

DEB and RPM packages of the most recent release are available in our own package
repository and we provide an installer script for convenience.

{% include pages/install/section.html os="Linux" %}

## MacOS

The Crystal project provides universal archives for MacOS that work on both,
Apple Silicon and Intel.

The most popular installation method is via Homebrew.

{% include pages/install/section.html os="MacOS" %}

<a id="windows"></a>

## Windows (preview)

> **NOTE:**
> Windows support is currently a preview and <a href="https://github.com/crystal-lang/crystal/issues/5430">not yet complete</a>,
> but largely usable.

Official builds are available as a ZIP archive or installer.

{% include pages/install/section.html os="Windows" %}

## FreeBSD

{% include pages/install/section.html os="FreeBSD" %}

## OpenBSD

{% include pages/install/section.html os="OpenBSD" %}

## Android

{% include pages/install/section.html os="Android" %}

## Docker

{% include pages/install/section.html os="Docker" %}

## Developer Tools

{% include pages/install/section.html os="Tools" %}

## Nightly builds

Nightly builds are the bleeding-edge version of Crystal, being a daily snapshot
of the current development status in the [`master` branch](https://github.com/crystal-lang/crystal/tree/master).
This is inherently less stable than proper a release, but allows trying out new
features and testing compatibility with existing code bases.
It's recomended to test against nightlies regularly in order to notice any issues
timely and avoid surprises after the next relase.

[**Read more about _Nightly Builds_**](/install/nightly/)

<a id="from_source"></a>

## Building from Source

The Crystal compiler is self-hosted, so in order to build it you need a Crystal compiler.
Hence from source installation is not an ideal way to get Crystal in the first place.
However it is possible to bootstrap from a different platform through cross-compiling.

<a href="from_sources">Instructions</a>

> **NOTE:** Getting Started
> Once you have Crystal installed, check out the [getting started guide](https://crystal-lang.org/reference/getting_started/).

<script src="/assets/js/copy-action.js"></script>
<script>
document.querySelectorAll(".install-entry pre").forEach(copy_action)
</script>
