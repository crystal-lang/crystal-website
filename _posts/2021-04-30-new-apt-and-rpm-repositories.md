---
title: Announcing new apt and rpm repositories
summary: Binary packages built and distributed on the Open Build Service
thumbnail: +
author: straight-shoota
---

With our previous distribution hosting at [bintray](https://bintray.com/crystal)
shutting down, we transitioned to the [Open Build Service (OBS)](https://build.opensuse.org),
a cross-platform package building service provided by openSUSE.

Instead of just hosting the packages, it takes care of the entire build process.
For now we continue to provide deb and rpm repositories for x86_64 and i686,
but more platforms and architectures will follow.

All packages are available on OBS at [build.opensuse.org/package/show/devel:languages:crystal](https://build.opensuse.org/project/show/devel:languages:crystal).
It offers an [installation page](https://software.opensuse.org/download.html?project=devel%3Alanguages%3Acrystal&package=crystal) with detailed instructions for the many different
target systems.
Our own installation instructions at [crystal-lang.org/install](/install) have been updated,
including the automatic installer script.

Since bintray is shutting down all operations on May 1st, 2021 our previous repositories
won't be available anymore. Please update to the new OBS repositories.
Running the updated installation script should override the previous configuration
in  `/etc/apt/sources.list.d/crystal.list` and  `/etc/yum.repos.d/crystal.repo`.

```shell-session
$ curl -fsSL https://crystal-lang.org/install.sh | sudo bash
```

Only the latest stable release Crystal 1.0.0 is available in the new
package repositories.
Thus the `--channel` flag on the installation script is currently ignored,
and `--crystal` only allows the values `latest` and `1.0.0` (with identical semantics).
Nightly builds and unstable releases will be available in the future.
