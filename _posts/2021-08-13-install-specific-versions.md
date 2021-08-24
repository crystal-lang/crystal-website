---
title: Installing specific versions of Crystal's binary packages
summary: Binary packages are now available for older releases on the Open Build Service
thumbnail: +
author: straight-shoota
---

When we [moved hosting of Crystal's binary packages](/2021/04/30/new-apt-and-rpm-repositories.html) to the [Open Build Service (OBS)](https://build.opensuse.org),
in May 2021, only the latest release (1.0.0 at that time) was available.

Since then, there have been more releases (1.1.0 and 1.1.1) but in the package repositories only the latest one was available at any time.

We've now added support for installing specific releases of Crystal via OBS.
There are individual packages for each minor release.

At the moment, there are three different packages available at [build.opensuse.org/package/show/devel:languages:crystal](https://build.opensuse.org/project/show/devel:languages:crystal):

* `crystal1.0` (1.0.0)
* `crystal1.1` (1.1.1)
* `crystal` (1.1.1)

The non-versioned `crystal` package keeps tracking the latest stable release,
versioned packages keep tracking the latest patch release of the respective minor version.

The new versioned packages are available for all architectures in all repositories on OBS.

Our own installation instructions at [crystal-lang.org/install](/install) have been updated,
including the automatic installer script.

The installer script allows selecting the version to be installed via tha `--version=x.y` argument.
This argument was previously called `--crystal` and while this name continues to work, it is now considered deprecated.
