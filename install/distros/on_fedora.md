---
layout: install
distro: On Fedora
icon: install/fedora@2x.png
exclude: true
---

## Enable snaps on Fedora and install Crystal
Snaps are applications packaged with all their dependencies to run on all popular Linux distributions from a single build. They update automatically and roll back gracefully.

Snaps are discoverable and installable from the [Snap Store](https://snapcraft.io/store), an app store with an audience of millions.


## Enable snapd
Snap can be installed on Fedora from the command line:

```
sudo dnf install snapd
```

Either log out and back in again, or restart your system, to ensure snap’s paths are updated correctly.

To enable classic snap support, enter the following to create a symbolic link between ```/var/lib/snapd/snap``` and ```/snap```:

```
sudo ln -s /var/lib/snapd/snap /snap
```

## Install Crystal
To install Crystal, simply use the following command:

```
sudo snap install crystal --classic
```