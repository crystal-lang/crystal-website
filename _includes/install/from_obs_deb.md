## Official Crystal deb repository

To install latest stable Crystal release from the official Crystal repository hosted on the [Open Build Service](https://build.opensuse.org) run in your command line:

<div class="code_section">
{% highlight bash %}
curl -fsSL https://crystal-lang.org/install.sh | sudo bash
{% endhighlight bash %}
</div>

The install script accepts optional arguments to install or update to a release of another channel.

- `--version` with `major.minor` or `latest` value
- `--channel` with `stable`, `unstable`, or `nightly` value

<div class="code_section">
{% highlight bash %}
curl -fsSL https://crystal-lang.org/install.sh | sudo bash -s -- --channel=nightly
{% endhighlight bash %}
</div>

You can find more detailed information at the [announcement post](/2021/04/30/new-apt-and-rpm-repositories/).

### Manual setup

Insert your distribution name and release as `{REPOSITORY}` in the following script and you are all set.
You can find available options on the [installation page at OBS](https://software.opensuse.org/download.html?project=devel%3Alanguages%3Acrystal&package=crystal).

<div class="code_section">
{% highlight bash %}
echo "deb http://download.opensuse.org/repositories/devel:/languages:/crystal/{REPOSITORY}/ /" | sudo tee /etc/apt/sources.list.d/crystal.list

# Add signing key
curl -fsSL https://download.opensuse.org/repositories/devel:languages:crystal/{REPOSITORY}/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/crystal.gpg > /dev/null
{% endhighlight bash %}
</div>

Once the repository is configured you're ready to install Crystal:

```bash
sudo apt update
sudo apt install crystal
```

The following packages are not required, but recommended for using the respective features in the standard library:

```bash
sudo apt install libssl-dev      # for using OpenSSL
sudo apt install libxml2-dev     # for using XML
sudo apt install libyaml-dev     # for using YAML
sudo apt install libgmp-dev      # for using Big numbers
sudo apt install libz-dev        # for using crystal play
```

When a new Crystal version is released you can upgrade your system using:

<div class="code_section">
{% highlight bash %}
sudo apt update
sudo apt install crystal
{% endhighlight bash %}
</div>
