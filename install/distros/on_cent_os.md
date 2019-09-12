---
layout: install
distro: On Cent OS
icon: install/centos@2x.png
exclude: true
---

## Enable snaps on CentOS and install Crystal
Snaps are applications packaged with all their dependencies to run on all popular Linux distributions from a single build. They update automatically and roll back gracefully.

Snaps are discoverable and installable from the [Snap Store](https://snapcraft.io/store), an app store with an audience of millions.

## Enable snapd

Snap is available for CentOS 7.6+, and Red Hat Enterprise Linux 7.6+, from the Extra Packages for Enterprise Linux (EPEL) repository. The EPEL repository can be added to your system with the following command:

```
sudo yum install epel-release
```

Snap can now be installed as follows:

```
sudo yum install snapd
```

Once installed, the systemd unit that manages the main snap communication socket needs to be enabled:

```
sudo systemctl enable --now snapd.socket
```

To enable classic snap support, enter the following to create a symbolic link between /var/lib/snapd/snap and /snap:

```
sudo ln -s /var/lib/snapd/snap /snap
```

Either log out and back in again, or restart your system, to ensure snap’s paths are updated correctly.

## Install Crystal
To install Crystal, simply use the following command:

```
sudo snap install crystal --classic
```