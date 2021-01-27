## Official Crystal deb repository

To install latest stable Crystal release from the official Crystal repository hosted on [Bintray](https://bintray.com/beta/#/crystal/deb?tab=packages) run in your command line:

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

The deb repository declared with `deb_distribution=all` and `deb_component` is used for the channel.

- The valid channels are `stable`, `unstable`, or `nightly`.

Replace the desired `{CHANNEL}` in the following script and you are all set.

<div class="code_section">
{% highlight bash %}
echo "deb https://dl.bintray.com/crystal/deb all {CHANNEL}" | tee /etc/apt/sources.list.d/crystal.list

# Add repo metadata signign key (shared bintray signing key)
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 379CE192D401AB61
apt-get update
{% endhighlight bash %}
</div>

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
sudo apt install libz-dev        # for using crystal play
{% endhighlight bash %}</div>

When a new Crystal version is released you can upgrade your system using:

<div class="code_section">
{% highlight bash %}
sudo apt update
sudo apt install crystal
{% endhighlight bash %}
</div>
