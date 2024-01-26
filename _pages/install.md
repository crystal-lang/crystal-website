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
It might be some older version though. Third party package managers can be
more up to date.
DEB and RPM packages of the most recent release are available in our own package
repository.

{% include pages/install/section.html os="Linux" %}

## MacOS

{% include pages/install/section.html os="MacOS" %}

<a id="windows"></a>

## Windows (preview)

Windows support is currently a preview and <a href="https://github.com/crystal-lang/crystal/issues/5430">not yet complete</a>.

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

<a href="nightlies">Instructions</a>

<a id="from_source"></a>

## Building from Source

The Crystal compiler is self-hosted, so in order to build it you need a Crystal compiler.
Hence from source installation is not an ideal way to get Crystal in the first place.
However it is possible to bootstrap from a different platform through cross-compiling.

<a href="from_sources">Instructions</a>

## Getting Started

<a href="https://crystal-lang.org/reference/getting_started/">Get Started</a>

<a href="https://repology.org/project/crystal-lang/versions">Crystal on Repology</a>

<script src="/assets/js/copy-action.js"></script>
<script>
document.querySelectorAll(".install-entry pre").forEach(copy_action)
</script>
