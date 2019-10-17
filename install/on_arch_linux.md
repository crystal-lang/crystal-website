---
layout: install
subtitle: On Arch Linux
exclude: true
permalink: /install/on_arch_linux/
---

Arch Linux includes the Crystal compiler in the Community repository. You should also install `shards`, Crystal's dependency manager (see [The Shards command](../the_shards_command/README.md)).
[Snapcraft](#snapcraft) is also available.

## Install

<div class="code_section">
{% highlight bash %}
sudo pacman -S crystal shards
{% endhighlight bash %}
</div>

{% include install_from_snapcraft.md distro="arch" %}
