---
layout: install
distro: On Manjaro
icon: install/manjaro@2x.png
exclude: true
---

## Enable snaps on Manjaro Linux and install Crystal
Snaps are applications packaged with all their dependencies to run on all popular Linux distributions from a single build. They update automatically and roll back gracefully.

Snaps are discoverable and installable from the [Snap Store](https://snapcraft.io/store), an app store with an audience of millions.


## Enable snapd
Snapd can be installed from Manjaro’s Add/Remove Software application (Pamac), found in the launch menu. From the application, search for snapd, select the result, and click Apply.

Alternatively, snapd can be installed from the command line:

```
sudo pacman -S snapd
```

Once installed, the systemd unit that manages the main snap communication socket needs to be enabled:

```
sudo systemctl enable --now snapd.socket
```

To enable classic snap support, enter the following to create a symbolic link between ```/var/lib/snapd/snap``` and ```/snap```:

```
sudo ln -s /var/lib/snapd/snap /snap
```

Either log out and back in again, or restart your system, to ensure snap’s paths are updated correctly.

## Install Crystal
To install Crystal, simply use the following command:

```
sudo snap install crystal --classic
```