---
subtitle: Nightly Builds
---

Nightly builds of the Crystal compiler are available from these locations:

## Tarball

Tarballs with nightly builds are available for the following platforms:

* linux x86_64: [`https://artifacts.crystal-lang.org/dist/crystal-nightly-linux-x86_64.tar.gz`](https://artifacts.crystal-lang.org/dist/crystal-nightly-linux-x86_64.tar.gz)
* darwin universal (x86_64 and aarch64): [`https://artifacts.crystal-lang.org/dist/crystal-nightly-darwin-universal.tar.gz`](https://artifacts.crystal-lang.org/dist/crystal-nightly-darwin-universal.tar.gz)
* windows x86_64: [`https://nightly.link/crystal-lang/crystal/workflows/win/master/crystal.zip`](https://nightly.link/crystal-lang/crystal/workflows/win/master/crystal.zip)

See [*Install from tar.gz*](/install/from_targz) for further instructions.

## Docker

Nightly builds are available on the `nightly` tag on the [Docker repository of Crystal](https://hub.docker.com/r/crystallang/crystal/).

```shell
docker pull crystallang/crystal:nightly
```

## Homebrew

The [homebrew formula for Crystal](https://formulae.brew.sh/formula/crystal) provides the `HEAD` version for building from the `master` branch.

```shell
brew install crystal --HEAD
```

## Snapcraft

Nightly builds are available on the `edge` channel of the [Snapcraft repository of Crystal](https://snapcraft.io/crystal).

```shell
snap install crystal --classic --edge
```

## Scoop

Nightly builds are available via the package manager [Scoop](https://scoop.sh/) on Windows in the bucket [`https://github.com/neatorobito/scoop-crystal`](https://github.com/neatorobito/scoop-crystal):

```shell
scoop bucket add crystal-preview https://github.com/neatorobito/scoop-crystal
scoop install crystal-nightly
```

## From Sources

See [*Build from sources*](/install/from_sources) for further instructions and pull the content of the `master` branch, instead of a tagged release version.

```shell
wget https://github.com/crystal-lang/crystal/archive/refs/heads/master.zip
# or
git clone git@github.com:crystal-lang/crystal
```

## GitHub Actions

Nightly builds are available in GitHub Actions with the [install-crystal](https://github.com/crystal-lang/install-crystal) action.
