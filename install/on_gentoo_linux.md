---
subtitle: On Gentoo Linux
---

Gentoo Linux includes the Crystal compiler in the main overlay.

## Configuration

You might want to take a look at the available configuration flags first:

<div class="code_section">
{% highlight bash %}
# equery u dev-lang/crystal
[ Legend : U - final flag setting for installation]
[        : I - package is installed with flag     ]
[ Colors : set, unset                             ]
 * Found these USE flags for dev-lang/crystal-0.18.7:
 U I
 - - doc      : Add extra documentation (API, Javadoc, etc). It is recommended to enable per package instead of globally
 - - examples : Install examples, usually source code
 + + xml      : Use the dev-libs/libxml2 library to enable Crystal xml module
 + - yaml     : Use the dev-libs/libyaml library to enable Crystal yaml module
{% endhighlight bash %}
</div>

## Install

<div class="code_section">
{% highlight bash %}
su -
emerge -a dev-lang/crystal
{% endhighlight bash %}
</div>
