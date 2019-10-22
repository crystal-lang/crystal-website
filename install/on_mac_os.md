---
subtitle: On macOS
---

To easily install Crystal on macOS you can use [Homebrew](http://brew.sh/).

<div class="code_section">{% highlight bash %}
brew update
brew install crystal
{% endhighlight bash %}</div>

You should be able to install the latest version from homebrew. Crystal's core-team help maintain that formula.

Alternative there are `.tar.gz` and `.pkg` files in each [release](https://github.com/crystal-lang/crystal/releases) targeted for darwin. See [Install from a tar.gz](/install/from_targz)

## Upgrade

When a new Crystal version is released you can upgrade your system using:

<div class="code_section">{% highlight bash %}
brew update
brew upgrade crystal
{% endhighlight bash %}</div>

## Troubleshooting

### On macOS 10.11 (El Capitan)

If you get an error like:

<div class="code_section">{% highlight txt %}
ld: library not found for -levent
{% endhighlight txt %}</div>

you need to reinstall the command line tools and then select the default active toolchain:

<div class="code_section">{% highlight bash %}
xcode-select --install
xcode-select --switch /Library/Developer/CommandLineTools
{% endhighlight bash %}</div>

### On macOS 10.14 (Mojave)

If you get an error like:

<div class="code_section">{% highlight txt %}
ld: library not found for -lssl (this usually means you need to install the development package for libssl)
{% endhighlight txt %}</div>

you may need to install OpenSSL and link pkg-config to OpenSSL:

<div class="code_section">{% highlight bash %}
brew install openssl
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/local/opt/openssl/lib/pkgconfig
{% endhighlight bash %}</div>

As with other keg-only formulas there are some caveats shown in `brew info <formula>` that shows how to link `pkg-config` with this library.

The Crystal compiler will by default use `pkg-config` to find the locations of libraries to link with.
