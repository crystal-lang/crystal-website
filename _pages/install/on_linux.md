---
title: Linux
page_title: Install on Linux
---

Official DEB and RPM packages are available at [devel:languages:crystal](https://build.opensuse.org/project/show/devel:languages:crystal)
on the [Open Build Service (OBS)](https://build.opensuse.org) and we provide an
installer script for convenience.

Many Linux distributions provide Crystal in their system packages.
There are several community-maintained packages as well, see [the install overview](../#linux).

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

## Manual Packages

As an alternative to the automatic installer, OBS offers [installation instructions](https://software.opensuse.org/download.html?project=devel%3Alanguages%3Acrystal&package=crystal)
for many distribution package managers as well as binary downloads.

## Tarball

Alternatively, there are `.tar.gz` archives in each [release](https://github.com/crystal-lang/crystal/releases)
for x86-64. See [Install from a tar.gz](/install/from_targz) for instructions.
