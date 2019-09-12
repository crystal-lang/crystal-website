---
layout: install
distro: On Kubuntu
icon: install/freebsd@2x.png
exclude: true
---

## Enable snaps on Kubuntu and install Crystal
Snaps are applications packaged with all their dependencies to run on all popular Linux distributions from a single build. They update automatically and roll back gracefully.

Snaps are discoverable and installable from the [Snap Store](https://snapcraft.io/store), an app store with an audience of millions.


## Enable snapd
If you’re running [Kubuntu 16.04 LTS (Xenial Xerus)](https://kubuntu.org/) or later, including [Kubuntu 18.04 LTS (Bionic Beaver)](https://wiki.ubuntu.com/BionicBeaver/ReleaseNotes/Kubuntu) and [Kubuntu 18.10 (Cosmic Cuttlefish)](https://wiki.ubuntu.com/CosmicCuttlefish/ReleaseNotes/Kubuntu), you don’t need to do anything. Snap is already installed and ready to go.

Versions of Kubuntu between [14.04 LTS (Trusty Tahr)](https://kubuntu.org/news/kubuntu-14-04-lts[) and [15.10 (Wily Werewolf)](https://kubuntu.org/news/kubuntu-15-10) don’t include snap by default, but snap can be installed from the command line as follows:

```
sudo apt update
sudo apt install snapd
```

## Install Crystal
To install Crystal, simply use the following command:

```
sudo snap install crystal --classic
```