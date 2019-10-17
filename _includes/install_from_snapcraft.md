## Snapcraft

The Crystal snap requires to be run in classic confinement. If you have `snapd` installed you're ready to install Crystal:

<div class="code_section">{% highlight bash %}
sudo snap install crystal --classic
{% endhighlight bash %}</div>

You can also install the latest nightly build by using the `edge` channel.

<div class="code_section">{% highlight bash %}
sudo snap install crystal --classic --edge
{% endhighlight bash %}</div>

{% assign snapcraft_url = 'https://snapcraft.io/install/crystal/' | append: include.distro %}

Find further information at [Crystal's snapcraft page]({{ snapcraft_url }})
