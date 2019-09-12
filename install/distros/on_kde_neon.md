---
layout: install
distro: On KDE Neon
icon: install/kde@2x.png
exclude: true
---

## Enable snaps on KDE Neon and install Crystal
Snaps are applications packaged with all their dependencies to run on all popular Linux distributions from a single build. They update automatically and roll back gracefully.

Snaps are discoverable and installable from the [Snap Store](https://snapcraft.io/store), an app store with an audience of millions.


## Enable snapd
Snap can be installed from the command line. Open the Konsole terminal and enter the following:

```
sudo apt update
sudo apt install snapd
```

## Install Crystal
To install Crystal, simply use the following command:

```
sudo snap install crystal --classic
```