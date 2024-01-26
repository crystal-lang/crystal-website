---
page_title: Nightly Builds
layout: page-wide
page_class: page--segmented
description: |
  Daily snapshots of the current development status in the [`master` branch](https://github.com/crystal-lang/crystal/tree/master)
  provide the bleeding-edge version of Crystal.
---

Nightly builds are inherently less stable than proper releases.
But they allow trying out new features and ensuring compatibility for existing
code bases.

It's recomended to test against nightlies regularly in order to notice any issues
ahead of time and avoid surprises with the next relase.

## Linux

{% include pages/install/section.html os="Linux" channel="nightly" %}

## MacOS

{% include pages/install/section.html os="MacOS" channel="nightly" %}

<a id="windows"></a>

## Windows (preview)

{% include pages/install/section.html os="Windows" channel="nightly" %}

## Docker

{% include pages/install/section.html os="Docker" channel="nightly" %}

## Developer Tools

{% include pages/install/section.html os="Tools" channel="nightly" %}

## From Sources

See [*Build from sources*](../from_sources) for further instructions and pull the content of the `master` branch, instead of a tagged release version.
