---
subtitle: From tar.gz
---

You can download Crystal in a standalone `.tar.gz` file with everything you need to get started.

The latest files can be found on the [Releases page at GitHub](https://github.com/crystal-lang/crystal/releases).

Download the file for your platform and uncompress it. Inside it you will have a `bin/crystal` executable.

To make it simpler to use, you can create a symbolic link available in the path:

<div class="code_section">{% highlight bash %}
ln -s [full path to bin/crystal] /usr/local/bin/crystal
{% endhighlight bash %}</div>

Then you can invoke the compiler by just typing:

<div class="code_section">{% highlight bash %}
crystal --version
{% endhighlight bash %}</div>
