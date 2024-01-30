---
title: Tarball
page_title: Install from Tarball
---

You can download Crystal in a standalone `.tar.gz` file with everything you need to get started.

The latest files can be found on the [Releases page at GitHub](https://github.com/crystal-lang/crystal/releases). Nightly builds are available as well at [https://crystal-lang.org/install/nightlies/](/install/nightlies).

Download the file for your platform and uncompress it. Inside it you will have a `bin/crystal` executable.

To make it simpler to use, you can create a symbolic link available in the path:

```bash
ln -s /full/path/to/bin/crystal /usr/local/bin/crystal
```

Then you can invoke the compiler by just typing:

```bash
crystal --version
```

{% assign latest_release = site.releases | reverse | first %}
{% capture caption %}
Downloads for latest release {{ latest_release.version }}
{% endcapture %}

{% include pages/install/archive-table.html packages=site.data.packages caption=caption %}
{% include pages/install/archive-table.html packages=site.data.packages-nightly caption="Downloads for nightly build" %}
