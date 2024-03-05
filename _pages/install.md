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

Many Linux distribution provide Crystal in their system packages.
It might not be the most recent version though.
Third party package managers are typically more up to date.

DEB and RPM packages are available in our own package
repository and we provide an installer script for convenience.

{% include pages/install/section.html os="Linux" %}

Linux-based [Docker images](#docker) and [developer tools](#developer-tools) are also available.

[**Read more about installing on _Linux_**](/install/on_linux)

## MacOS

The Crystal project provides universal archives for MacOS that work on both,
Apple Silicon and Intel.

The most popular installation method is via Homebrew.

{% include pages/install/section.html os="MacOS" %}

Crystal is also available in [developer tooling](#developer-tools) on macOS.

[**Read more about installing on _MacOS_**](/install/on_mac_os)

<span id="windows"></span>

## Windows (preview)

> **NOTE:**
> Windows support is currently a preview and <a href="https://github.com/crystal-lang/crystal/issues/5430">not yet complete</a>,
> but largely usable.

Official builds are available as a ZIP archive or installer.

{% include pages/install/section.html os="Windows" %}

Crystal is also available in [developer tooling](#developer-tools) on Windows.

[**Read more about installing on _Windows_**](/install/on_windows)

## FreeBSD

{% include pages/install/section.html os="FreeBSD" %}

[**Read more about installing on _FreeBSD_**](/install/on_freebsd)

## OpenBSD

{% include pages/install/section.html os="OpenBSD" %}

[**Read more about installing on _OpenBSD_**](/install/on_openbsd)

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

[**Read more about _Nightly Builds_**](/install/nightlies/)

<span id="from_source"></span>

## Building from Source

The Crystal compiler is self-hosted, so in order to build it you need a Crystal compiler.
Hence from source installation is not an ideal way to get Crystal in the first place.
However it is possible to bootstrap from a different platform through cross-compiling.

[**Read more about _Building from Source_**](/install/from_sources/)

<script src="/assets/js/copy-action.js"></script>
<script>
document.querySelectorAll(".install-entry pre").forEach(copy_action)
</script>

<hr class="full-width-rule" />

{% include pages/install/cta.html %}
