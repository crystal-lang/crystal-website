---
title: Announcing new apt and rpm repositories
summary: We are moving to Bintray for apt and rpm repositories and we are adding stable, unstable, nightly channels.
thumbnail: +
author: bcardiff
---

**UPDATE:** As of 2021-05-01, the bintray repositories are no longer available. The distribution packages are now hosted
on the Open Build Service, see recent [blog post](https://crystal-lang.org/2021/04/30/new-apt-and-rpm-repositories.html).

We've been working on improving the state of the art of the official deb and rpm repositories.

The main outcome is that we will be able to:

- publish stable, unstable and nightly packages
- allow users to pick which crystal version to install
- allow tweaking dependencies when needed (ie: CentOS 6 vs others regarding libevent2-devel and libevent-devel)
- introduce a single installation script that, for now, will work with deb/rpm

This will allow:

- a more comfortable experience to end user
- relying on apt and rpm repositories for getting not only the latest crystal release
- testing nightly packages without requiring Docker or Snap
- simplifying adoption in other CI systems in case our Docker image is not suitable enough
- having statistics of version adoption
- eventually splitting the current package in compiler, shards and maybe tools

We will be hosting these packages at [https://bintray.com/crystal](https://bintray.com/crystal)

The current apt and rpm packages in [https://dist.crystal-lang.org](https://dist.crystal-lang.org/) will be available and receive stable updates until November 2020 as a transition period.

The [installation script](/install.sh) allows installing the latest stable version by default:

```shell-session
$ curl -fsSL https://crystal-lang.org/install.sh -o install.sh
$ chmod +x install.sh
$ sudo ./install.sh

# Or, to run it directly
$ curl -fsSL https://crystal-lang.org/install.sh | sudo bash

# Or, if you prefer wget
$ sudo bash -c "$(wget -O - https://crystal-lang.org/install.sh)"
```

Choose the channel, for example to pick nightly packages:

```shell-session
$ sudo ./install.sh --channel=nightly

# Or, to run it directly
$ curl -fsSL https://crystal-lang.org/install.sh | sudo bash -s -- --channel=nightly

# Or, if you prefer wget
$ sudo bash -c "$(wget -O - https://crystal-lang.org/install.sh)" -s -- --channel=nightly
```

Install a specific version as `major.minor.patch`, `major.minor` or `major.minor.patch-iteration`

```shell-session
$ sudo ./install.sh --crystal=0.35

# Or, to run it directly
$ curl -fsSL https://crystal-lang.org/install.sh | sudo bash -s -- --crystal=0.35

# Or, if you prefer wget
$ sudo bash -c "$(wget -O - https://crystal-lang.org/install.sh)" -s -- --crystal=0.35
```

In general, the install script accepts optional arguments

- `--crystal` with `major.minor.patch`, `major.minor`, or `major.minor.patch-iteration` values
- `--channel` with `stable`, `unstable`, or `nightly` value

It will identify the Linux distribution and use `yum` or `apt`.

The installation script requires `gnupg`, `ca-certificates`, and `apt-transport-https` packages that might be already available on your setup. It also needs to be run as root.

## What if I already have crystal installed via apt/rpm?

The installation script will overwrite `/etc/apt/sources.list.d/crystal.list` and  `/etc/yum.repos.d/crystal.repo` on every execution. These are the same files used in the former official apt and rpm repositories.

If you already have the latest version of Crystal (0.35.1) and run the installation scripts you will see

```shell-session
# Debian/Ubuntu
... stripped ...
crystal is already the newest version (0.35.1-1).
0 upgraded, 0 newly installed, 0 to remove and 2 not upgraded.

# CentOS/Fedora
... stripped ...
Package crystal-0.35.1-1.x86_64 already installed and latest version
Nothing to do
```

This happens when there is no newer version in the new repository. If you switch to the nightly channel you will get 1.0.0-dev.

You can run `apt -y remove crystal` or `rpm -e crystal` to remove the current installed Crystal and then execute the installation script.

## Caveats

The installation script will upgrade to a newer crystal, but will not downgrade.

If you already have 0.35.1 and wish to downgrade to the latest 0.34 you will get the following output.

```shell-session
$ ./install.sh --crystal=0.34

# Debian/Ubuntu
... stripped ...
Selected version '0.34.0-1' (Bintray:all [amd64]) for 'crystal'
Suggested packages:
  libxml2-dev libgmp-dev libyaml-dev libreadline-dev
The following packages will be DOWNGRADED:
  crystal
0 upgraded, 0 newly installed, 1 downgraded, 0 to remove and 2 not upgraded.
E: Packages were downgraded and -y was used without --allow-downgrades.

# CentOS/Fedora
... stripped ...
Package matching crystal-0.34.0-1.x86_64 already installed. Checking for update.
Nothing to do
```

Instead of forcing a downgrade in the installation script we require you to explicitly uninstall crystal before a downgrade.

```shell-session
# Debian/Ubuntu
$ apt -y remove crystal
$ ./install.sh --crystal=0.34

# CentOS/Fedora
$ rpm -e crystal
$ ./install.sh --crystal=0.34
```

When switching between channels you might need to clear the cached metadata.

```shell-session
$ yum clean metadata
```

<br/>

---

What follows is a description of how these repositories are laid out for the sake of documentation.

## deb repository

The deb repository declared with `deb_distribution=all` and `deb_component` is used for the channel.

```txt
deb https://dl.bintray.com/crystal/deb all stable
deb https://dl.bintray.com/crystal/deb all unstable
deb https://dl.bintray.com/crystal/deb all nightly
```

Luckily the dependencies of all deb distributions are the same and there is no need, at least for now, to distinguish between them.

Packages for amd64 and i386 are published.

The repository metadata is signed with the Bintray shared GPG key

```shell-session
$ apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 379CE192D401AB61
```

The deb packages in stable and unstable channels are signed with our own GPG key.

The deb packages in the nightly channel are not signed.

When installing via `apt` only the repository metadata signature is checked, so there is no need to add our own key in general.

```shell-session
$ curl -sL "https://keybase.io/crystal/pgp_keys.asc" | apt-key add -
```

## rpm repository

The rpm repository required a bit more fine tuning. The url of the repo is `https://dl.bintray.com/crystal/rpm/{DISTRO}/{ARCH}/{CHANNEL}`. In terms of Bintray configuration we use `yum_metadata_depth=3` .

We will be using two `{DISTRO}` values: `el6` and `all`. This is enough, for now, to support CentOS 6/7/8, Fedora. (Note: if CentOS 6/7 shipped with rpm >= 4.13 then a single package would have been enough with `libevent-devel >= 2.0 or libevent2-devel` as a dependency).

The only supported `{ARCH}` for rpm is `x86_64`.

And `{CHANNEL}` is either `stable`, `unstable`, or `nightly`.

As before, the repository metadata is signed with the Bintray shared GPG key and the packages are signed with our own key, except for the nightly channel.

Replace the `{DISTRO}` and `{CHANNEL}` and you are all set.

```txt
[crystal]
name=Crystal
baseurl=https://dl.bintray.com/crystal/rpm/{DISTRO}/x86_64/{CHANNEL}
gpgcheck=0
repo_gpgcheck=1
gpgkey=http://bintray.com/user/downloadSubjectPublicKey?username=bintray
```

<br/>

---

## Next steps

We plan to release an unstable 1.0.0-pre1 so we needed to formalise how tagged unstable releases are advertised. The 1.0.0-pre1 release will be the first one to land on the unstable channel, which is currently empty.

There are also some draft ideas to formalize how .tar.gz will be advertised in channels.

The advertised installation methods will be updated to reflect these new repositories.

The CI integrations shall be updated also and might include some new features to pick a specific crystal version and channel.
