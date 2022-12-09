---
subtitle: On OpenSUSE and SUSE Linux Enterprise (SLE)
---

On OpenSUSE, Crystal can be installed from the official repository hosted on the [Open Build Service](https://build.opensuse.org) using Zypper.
[Snapcraft](#snapcraft) is also available.

## Setup repository

Configure the repository in Zypper:

For OpenSUSE Tumbleweed :
<div class="code_section">
{% highlight bash %}
sudo zypper ar -f https://download.opensuse.org/repositories/devel:/languages:/crystal/openSUSE_Tumbleweed/devel:languages:crystal.repo
{% endhighlight bash %}
</div>

For OpenSUSE Leap 15.2:
<div class="code_section">
{% highlight bash %}
sudo zypper ar -f https://download.opensuse.org/repositories/devel:/languages:/crystal/openSUSE_Leap_15.2/devel:languages:crystal.repo
{% endhighlight bash %}
</div>

## Install

Once the repository is configured, Crystal can be installed:

<div class="code_section">
{% highlight bash %}
sudo zypper --gpg-auto-import-keys install crystal
{% endhighlight bash %}
</div>

## Upgrade

When a new Crystal version is released you can upgrade Crystal using the default update command of your distribution:

On OpenSUSE Tumbleweed :
<div class="code_section">
{% highlight bash %}
sudo zypper dup
{% endhighlight bash %}
</div>

On OpenSUSE Leap :
<div class="code_section">
{% highlight bash %}
sudo zypper up
{% endhighlight bash %}
</div>

## Repo change

If you used the old bintray repo, you may need to switch repos to keep updating correctly

Add the new repo then

On Tumbleweed :
<div class="code_section">
{% highlight bash %}
sudo zypper dup --from https://download.opensuse.org/repositories/devel:/languages:/crystal/openSUSE_Tumbleweed/ --allow-vendor-change
sudo zypper rr https://dl.bintray.com/crystal/rpm/all/x86_64/stable
{% endhighlight bash %}
</div>

Leap 15.2 :
<div class="code_section">
{% highlight bash %}
sudo zypper dup --from https://download.opensuse.org/repositories/devel:/languages:/crystal/openSUSE_Leap_15.2/ --allow-vendor-change
sudo zypper rr https://dl.bintray.com/crystal/rpm/all/x86_64/stable
{% endhighlight bash %}
</div>

{% include install_from_snapcraft.md distro="opensuse" %}
