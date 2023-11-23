---
title: Linux
page_title: Install on Linux
---

We're building official DEB and RPM packages in the [Open Build Service (OBS)](https://build.opensuse.org),
a cross-platform package building service provided by openSUSE.
They are available in the [devel:languages:crystal](https://build.opensuse.org/project/show/devel:languages:crystal) project.

Many Linux distribution have Crystal available in their system packages, and
there are also several community packages, see [the install overview](../#linux).

## Installer

We provide an installer script that automatically sets up the OBS package sources
for DEB- and RPM-based package managers and installs the respective `crystal` package.

To install the latest stable Crystal release:

```bash
curl -fsSL https://crystal-lang.org/install.sh | sudo bash
```

The install script accepts optional arguments for selecting a specific Crystal version.

- `--version` with `major.minor` or `latest` value
- `--channel` with `stable`, `unstable`, or `nightly` value

Install nightly build:

```bash
curl -fsSL https://crystal-lang.org/install.sh | sudo bash -s -- --channel=nightly
```

Install the 1.10 release:

```bash
curl -fsSL https://crystal-lang.org/install.sh | sudo bash -s -- --version=1.10
```

## Manual

As an alternative to the automatic installer, OBS offers [installation instructions](https://software.opensuse.org/download.html?project=devel%3Alanguages%3Acrystal&package=crystal)
for many distribution package managers as well as binary downloads.
