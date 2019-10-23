---
subtitle: On Kubuntu
---

In Ubuntu derived distributions, you can use the official Crystal repository. [Snapcraft](#snapcraft) and [Linuxbrew](#linuxbrew) are also available.

## Setup repository

First you have to add the repository to your APT configuration. For easy setup just run in your command line:

<div class="code_section">{% highlight bash %}
curl -sSL https://dist.crystal-lang.org/apt/setup.sh | sudo bash
{% endhighlight bash %}</div>

That will add the signing key and the repository configuration. If you prefer to do it manually, execute the following commands:

<div class="code_section">{% highlight bash %}
curl -sL "https://keybase.io/crystal/pgp_keys.asc" | sudo apt-key add -
echo "deb https://dist.crystal-lang.org/apt crystal main" | sudo tee /etc/apt/sources.list.d/crystal.list
sudo apt-get update
{% endhighlight bash %}</div>

## Install

Once the repository is configured you're ready to install Crystal:

<div class="code_section">{% highlight bash %}
sudo apt install crystal
{% endhighlight bash %}</div>

The following packages are not required, but recommended for using the respective features in the standard library:

<div class="code_section">{% highlight bash %}
sudo apt install libssl-dev      # for using OpenSSL
sudo apt install libxml2-dev     # for using XML
sudo apt install libyaml-dev     # for using YAML
sudo apt install libgmp-dev      # for using Big numbers
sudo apt install libreadline-dev # for using Readline
sudo apt install libz-dev        # for using crystal play
{% endhighlight bash %}</div>

## Upgrade

When a new Crystal version is released you can upgrade your system using:

<div class="code_section">{% highlight bash %}
sudo apt update
sudo apt install crystal
{% endhighlight bash %}</div>

{% include install_from_snapcraft.md distro="kubuntu" %}
{% include install_from_linuxbrew.md %}
