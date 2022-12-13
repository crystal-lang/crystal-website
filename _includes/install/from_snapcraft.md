## Snapcraft

The Crystal snap requires to be run in classic confinement. If you have `snapd` installed you're ready to install Crystal:

```bash
sudo snap install crystal --classic
```

You can also install the latest nightly build by using the `edge` channel.

```bash
sudo snap install crystal --classic --edge
```

{% assign snapcraft_url = 'https://snapcraft.io/install/crystal/' | append: include.distro %}

Find further information at [Crystal's snapcraft page]({{ snapcraft_url }})
