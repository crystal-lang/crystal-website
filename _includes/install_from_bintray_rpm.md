## Official Crystal rpm repository

To install latest stable Crystal release from the official Crystal repository hosted on [Bintray](https://bintray.com/beta/#/crystal/rpm?tab=packages) run in your command line:

<div class="code_section">
{% highlight bash %}
curl -fsSL https://crystal-lang.org/install.sh | sudo bash
{% endhighlight bash %}
</div>

The install script accepts optional arguments to install or update to a release of another channel.

- `--crystal` with `major.minor.patch`, `major.minor`, or `major.minor.patch-iteration` values
- `--channel` with `stable`, `unstable`, or `nightly` value

<div class="code_section">
{% highlight bash %}
curl -fsSL https://crystal-lang.org/install.sh | sudo bash -s -- --channel=nightly
{% endhighlight bash %}
</div>

You can find more detailed information at the [announcement post](/2020/08/24/announcing-new-apt-and-rpm-repositories.html).

### Manual setup

The url of the repo is `https://dl.bintray.com/crystal/rpm/{DISTRO}/{ARCH}/{CHANNEL}`.

- The valid `{DISTRO}` values are `el6` and `all`.
- The only supported `{ARCH}` for rpm is `x86_64`.
- The valid `{CHANNEL}` values are `stable`, `unstable`, or `nightly`.

Replace the desired `{DISTRO}` and `{CHANNEL}` in the following script and you are all set.

<div class="code_section">
{% highlight bash %}
cat > /etc/yum.repos.d/crystal.repo <<END
[crystal]
name=Crystal
baseurl=https://dl.bintray.com/crystal/rpm/{DISTRO}/x86_64/{CHANNEL}
gpgcheck=0
repo_gpgcheck=1
gpgkey=http://bintray.com/user/downloadSubjectPublicKey?username=bintray
END

{% endhighlight bash %}
</div>

Once the repository is configured you're ready to install Crystal:

<div class="code_section">
{% highlight bash %}
sudo yum install crystal
{% endhighlight bash %}
</div>

When a new Crystal version is released you can upgrade your system using:

<div class="code_section">
{% highlight bash %}
sudo yum update crystal
{% endhighlight bash %}
</div>
