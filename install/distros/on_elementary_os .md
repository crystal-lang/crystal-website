---
layout: install
distro: On Elementary OS
icon: install/elementary@2x.png
exclude: true
---

## Enable snaps on elementary OS and install Crystal
Snaps are applications packaged with all their dependencies to run on all popular Linux distributions from a single build. They update automatically and roll back gracefully.

Snaps are discoverable and installable from the [Snap Store](https://snapcraft.io/store), an app store with an audience of millions.


## Enable snapd
Snap can be installed on elementary OS from the command line. Open Terminal from the Applications launcher and type the following:

```
sudo apt update
sudo apt install snapd
```

Either log out and back in again, or restart your system, to ensure snap’s paths are updated correctly.

## Install Crystal
To install Crystal, simply use the following command:

```
sudo snap install crystal --classic
```