---
subtitle: On OpenSUSE and SUSE Linux Enterprise (SLE)
---

On OpenSUSE, Crystal can be installed from the official repository hosted on the [Open Build Service](https://build.opensuse.org) using Zypper.
[Snapcraft](#snapcraft) is also available.

## Setup repository

Configure the repository in Zypper:

For OpenSUSE Tumbleweed :
```bash
sudo zypper ar -f https://download.opensuse.org/repositories/devel:/languages:/crystal/openSUSE_Tumbleweed/devel:languages:crystal.repo
```

For OpenSUSE Leap 15.2:
```bash
sudo zypper ar -f https://download.opensuse.org/repositories/devel:/languages:/crystal/openSUSE_Leap_15.2/devel:languages:crystal.repo
```

## Install

Once the repository is configured, Crystal can be installed:

```bash
sudo zypper --gpg-auto-import-keys install crystal
```

## Upgrade

When a new Crystal version is released you can upgrade Crystal using the default update command of your distribution:

On OpenSUSE Tumbleweed :
```bash
sudo zypper dup
```

On OpenSUSE Leap :
```bash
sudo zypper up
```

## Repo change

If you used the old bintray repo, you may need to switch repos to keep updating correctly

Add the new repo then

On Tumbleweed :
```bash
sudo zypper dup --from https://download.opensuse.org/repositories/devel:/languages:/crystal/openSUSE_Tumbleweed/ --allow-vendor-change
sudo zypper rr https://dl.bintray.com/crystal/rpm/all/x86_64/stable
```

Leap 15.2 :
```bash
sudo zypper dup --from https://download.opensuse.org/repositories/devel:/languages:/crystal/openSUSE_Leap_15.2/ --allow-vendor-change
sudo zypper rr https://dl.bintray.com/crystal/rpm/all/x86_64/stable
```

{% include install_from_snapcraft.md distro="opensuse" %}
