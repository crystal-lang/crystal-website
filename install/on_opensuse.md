---
subtitle: On OpenSUSE
---

On OpenSUSE, Crystal can be installed from the official rpm package using Zypper.
[Snapcraft](#snapcraft) is also available.

## Setup repository

First add the signing key:

<div class="code_section">
{% highlight bash %}
rpm --import https://dist.crystal-lang.org/rpm/RPM-GPG-KEY
{% endhighlight bash %}
</div>

Next configure the repository in Zypper:

<div class="code_section">
{% highlight bash %}
sudo zypper ar -e -f -t rpm-md https://dist.crystal-lang.org/rpm/ Crystal
{% endhighlight bash %}
</div>

## Install

Once the repository is configured, Crystal can be installed:

<div class="code_section">
{% highlight bash %}
sudo zypper install crystal
{% endhighlight bash %}
</div>

## Upgrade

When a new Crystal version is released you can upgrade Crystal using:

<div class="code_section">
{% highlight bash %}
sudo zypper update crystal
{% endhighlight bash %}
</div>

{% include install_from_snapcraft.md distro="opensuse" %}
