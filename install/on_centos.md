---
subtitle: On CentOS
---

In Red Hat derived distributions, you can use the official Crystal repository.
[Snapcraft](#snapcraft) and [Linuxbrew](#linuxbrew) are also available.

## Setup repository

First you have to add the repository to your YUM configuration. For easy setup just run in your command line:

<div class="code_section">
{% highlight bash %}
curl https://dist.crystal-lang.org/rpm/setup.sh | sudo bash
{% endhighlight bash %}
</div>

That will add the signing key and the repository configuration. If you prefer to do it manually execute:

<div class="code_section">
{% highlight bash %}
rpm --import https://dist.crystal-lang.org/rpm/RPM-GPG-KEY

cat > /etc/yum.repos.d/crystal.repo <<END
[crystal]
name = Crystal
baseurl = https://dist.crystal-lang.org/rpm/
END

{% endhighlight bash %}
</div>

## Install
Once the repository is configured you're ready to install Crystal:

<div class="code_section">
{% highlight bash %}
sudo yum install crystal
{% endhighlight bash %}
</div>

## Upgrade

When a new Crystal version is released you can upgrade your system using:

<div class="code_section">
{% highlight bash %}
sudo yum update crystal
{% endhighlight bash %}
</div>

{% include install_from_snapcraft.md distro="centos" %}
{% include install_from_linuxbrew.md %}
