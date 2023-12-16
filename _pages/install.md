---
title: Install
permalink: /install
layout: page-wide
page_class: page--segmented
---
## Linux

Many Linux distribution have Crystal available in their system packages.
It might be some older version though. Third party package managers can be
more up to date.
DEB and RPM packages of the most recent release are available in our own package
repository.

<div class="install-panels">
  <div class="install-group">
    <h5>Crystal</h5>
    <div class="install-entries">
      <div class="install-entry">
        <span class="title"><a href="on_linux#installer" title="Instructions for Linux installer">Installer (DEB &amp; RPM)</a></span>
        {% highlight shell %}curl -fsSL https://crystal-lang.org/install.sh | sudo bash{% endhighlight %}
        <a href="https://build.opensuse.org/project/show/devel:languages:crystal" title="Crystal repository on OBS" class="info">{% include icons/info.svg %}</a>
      </div>
      <div class="install-entry">
        <span class="title"><a href="from_targz/">Tarball</a></span>
        <p>
          Archive in <a href="https://github.com/crystal-lang/crystal/releases">the latest release</a>.
        </p>
      </div>
    </div>
  </div>
  <div class="install-group">
    <h5>System</h5>
    <div class="install-entries">
      <div class="install-entry">
        <span class="title">APT (Debian, Ubuntu, etc.)</span>
        {% highlight shell %}apt install crystal{% endhighlight %}
        <a href="https://packages.debian.org/sid/source/crystal" title="Crystal package in Debian sid/unstable" class="info">{% include icons/info.svg %}</a>
        {% include elements/repology_badge.html repo="debian_unstable/crystal-lang" %}
      </div>
      <div class="install-entry">
        <span class="title">Apk (Alpine Linux)</span>
        {% highlight shell %}apk add crystal shards{% endhighlight %}
        <a href="https://pkgs.alpinelinux.org/packages?name=crystal" title="Crystal package on Alpine Linux package index" class="info">{% include icons/info.svg %}</a>
        {% include elements/repology_badge.html repo="alpine_edge/crystal-lang" %}
      </div>
      <div class="install-entry">
        <span class="title">Pacman (Arch Linux)</span>
        {% highlight shell %}pacman -S crystal shards{% endhighlight %}
        <a href="https://archlinux.org/packages/extra/x86_64/crystal/" title="Crystal package on Arch Linux package index" class="info">{% include icons/info.svg %}</a>
        {% include elements/repology_badge.html repo="arch/crystal-lang" %}
      </div>
      <div class="install-entry">
        <span class="title"><a href="on_gentoo_linux/">Emerge (Gentoo)</a></span>
        {% highlight shell %}emerge -a dev-lang/crystal{% endhighlight %}
        <a href="https://packages.gentoo.org/packages/dev-lang/crystal" title="Crystal package on Gentoo package index" class="info">{% include icons/info.svg %}</a>
        {% include elements/repology_badge.html repo="gentoo/crystal-lang" %}
      </div>
    </div>
  </div>
  <div class="install-group">
    <h5>Community</h5>
    <div class="install-entries">
      <div class="install-entry">
        <span class="title">Homebrew/<wbr />Linuxbrew</span>
        {% highlight shell %}brew install crystal{% endhighlight %}
        <a href="https://formulae.brew.sh/formula/crystal" title="Crystal package on Homebrew" class="info">{% include icons/info.svg %}</a>
        {% include elements/repology_badge.html repo="homebrew/crystal-lang" %}
      </div>
      <div class="install-entry">
        <span class="title"><a href="from_asdf">asdf</a></span>
        {% highlight shell %}asdf plugin add crystal
          asdf install crystal latest
        {% endhighlight %}
        <a href="https://github.com/asdf-community/asdf-crystal" title="Crystal plugin for ASDF on GitHub" class="info">{% include icons/info.svg %}</a>
      </div>
      <div class="install-entry">
        <span class="title"><a href="from_snapcraft/">Snapcraft</a></span>
        {% highlight shell %}snap install crystal --classic{% endhighlight %}
        <a href="https://snapcraft.io/crystal" title="Crystal on Snapcraft" class="info">{% include icons/info.svg %}</a>
      </div>
      <div class="install-entry">
        <span class="title">Nix</span>
        <p><code>crystal</code> package.</p>
        <a href="https://search.nixos.org/packages?show=crystal&channel=unstable&from=0&size=50&sort=relevance&type=packages&query=crystal" title="Crystal on Nix package search" class="info">{% include icons/info.svg %}</a>
        {% include elements/repology_badge.html repo="nix_unstable/crystal-lang" %}
      </div>
      <div class="install-entry">
        <span class="title">DEB &amp; RPM (x86_64 &amp; aarch64)</span>
        <a href="https://packagecloud.io/84codes/crystal" title="84codes' Crystal package on packagecloud.io" class="info">{% include icons/info.svg %}</a>
      </div>
    </div>
  </div>
</div>

## MacOS

<div class="install-panels">
  <div class="install-group">
    <h5>Crystal</h5>
    <div class="install-entries">
      <div class="install-entry">
      <span class="title"><a href="from_targz/">Tarball</a></span>
        <p>Archive in the <a href="https://github.com/crystal-lang/crystal/releases">the latest release</a>.</p>
      </div>
    </div>
  </div>
  <div class="install-group">
    <h5>Community</h5>
    <div class="install-entries">
      <div class="install-entry">
      <span class="title">Homebrew</span>
        {% highlight shell %}brew install crystal{% endhighlight %}
        <a href="https://formulae.brew.sh/formula/crystal" title="Crystal package on Homebrew" class="info">{% include icons/info.svg %}</a>
        {% include elements/repology_badge.html repo="homebrew/crystal-lang" %}
      </div>
      <div class="install-entry">
      <span class="title"><a href="from_asdf">asdf</a></span>
        {% highlight shell %}asdf plugin add crystal
          asdf install crystal latest{% endhighlight %}
        <a href="https://github.com/asdf-community/asdf-crystal" title="Crystal plugin for ASDF on GitHub" class="info">{% include icons/info.svg %}</a>
      </div>
      <div class="install-entry">
      <span class="title">Nix</span>
        <p><code>crystal</code> package.</p>
        <a href="https://search.nixos.org/packages?show=crystal&channel=unstable&from=0&size=50&sort=relevance&type=packages&query=crystal" title="Crystal on Nix package search" class="info">{% include icons/info.svg %}</a>
        {% include elements/repology_badge.html repo="nix_unstable/crystal-lang" %}
      </div>
      <div class="install-entry">
      <span class="title">MacPorts</span>
        {% highlight shell %}port install crystal{% endhighlight %}
        <a href="https://ports.macports.org/port/crystal/summary/" title="Crystal port on MacPorts package index" class="info">{% include icons/info.svg %}</a>
        {% include elements/repology_badge.html repo="macports/crystal-lang" %}
      </div>
    </div>
  </div>
</div>

<a id="windows"></a>

## Windows (preview)

Windows support is currently a preview and <a href="https://github.com/crystal-lang/crystal/issues/5430">not yet complete</a>.

<div class="install-panels">
  <div class="install-group">
  <h5>Crystal</h5>
    <div class="install-entries">
      <div class="install-entry">
        <span class="title"><a href="on_windows">Installer</a></span>
        <p>
          Installer (<code>.exe</code>) in <a href="https://github.com/crystal-lang/crystal/releases">the latest release</a>.
        </p>
      </div>
      <div class="install-entry">
        <span class="title"><a href="on_windows">Portable Archive</a></span>
        <p>
          Archive (<code>.zip</code>) in <a href="https://github.com/crystal-lang/crystal/releases">the latest release</a>.
        </p>
      </div>
    </div>
  </div>
  <div class="install-group">
  <h5>Community</h5>
    <div class="install-entries">
      <div class="install-entry">
        <span class="title"><a href="from_scoop">Scoop</a></span>
        {% highlight powershell %}scoop install git
          scoop bucket add crystal-preview https://github.com/neatorobito/scoop-crystal
          scoop install vs_2022_cpp_build_tools crystal
        {% endhighlight %}
        <a href="https://github.com/neatorobito/scoop-crystal" title="Scoop repository for Crystal on GitHub" class="info">{% include icons/info.svg %}</a>
      </div>
      <div class="install-entry">
        <span class="title">WinGet</span>
        <a href="https://github.com/microsoft/winget-pkgs/tree/master/manifests/c/CrystalLang/Crystal/" title="Crystal manifest in WinGet packages repository" class="info">{% include icons/info.svg %}</a>
        {% include elements/repology_badge.html repo="winget/crystal-lang" %}
      </div>
    </div>
  </div>
</div>

## FreeBSD

<div class="install-panels">
  <div class="install-group">
    <h5>System</h5>
    <div class="install-entries">
      <div class="install-entry">
        <span class="title"><a href="on_freebsd/#install-package">Package</a></span>
        {% highlight shell %}sudo pkg install -y crystal shards{% endhighlight %}
      </div>
      <div class="install-entry">
        <span class="title"><a href="on_freebsd/#install-port">Port</a></span>
        {% highlight shell %}sudo make -C/usr/ports/lang/crystal reinstall clean
          sudo make -C/usr/ports/devel/shards reinstall clean
        {% endhighlight %}
        <a href="https://www.freshports.org/lang/crystal" title="Crystal port on Freshports.org" class="info">{% include icons/info.svg %}</a>
        {% include elements/repology_badge.html repo="freebsd/crystal-lang" %}
      </div>
    </div>
  </div>
</div>

## OpenBSD

<div class="install-panels">
  <div class="install-group">
    <h5>System</h5>
    <div class="install-entries">
      <div class="install-entry">
        <span class="title"><a href="on_openbsd/#install-package">Package</a></span>
        {% highlight shell %}doas pkg_add crystal{% endhighlight %}
      </div>
      <div class="install-entry">
        <span class="title"><a href="on_openbsd/#install-port">Port</a></span>
        {% highlight shell %}doas make -C/usr/ports/lang/crystal clean install{% endhighlight %}
        <a href="https://openports.pl/path/lang/crystal" title="Crysta port on openports.pl" class="info">{% include icons/info.svg %}</a>
        {% include elements/repology_badge.html repo="openbsd/crystal-lang" %}
      </div>
    </div>
  </div>
</div>

## Android

<div class="install-panels">
  <div class="install-group">
    <h5>Community</h5>
    <div class="install-entries">
      <div class="install-entry">
        <span class="title"><a href="on_termux/">Termux</a></span>
        {% highlight shell %}pkg install crystal{% endhighlight %}
        <a href="https://github.com/termux/termux-packages/tree/master/packages/crystal" title="Crystal package manifest in the Termux package repository on GitHub" class="info">{% include icons/info.svg %}</a>
        {% include elements/repology_badge.html repo="termux/crystal-lang" %}
      </div>
    </div>
  </div>
</div>

## Developer Tools

<div class="install-panels">
  <div class="install-group">
    <h5>Crystal</h5>
    <div class="install-entries">
      <div class="install-entry">
        <span class="title">Docker</span>
        {% highlight shell %}docker pull crystallang/crystal{% endhighlight %}
        <a href="https://hub.docker.com/r/crystallang/crystal/" title="Crystal image on Docker Hub" class="info">{% include icons/info.svg %}</a>
      </div>
      <div class="install-entry">
        <span class="title"><a href="https://crystal-lang.github.io/install-crystal/">GitHub Actions</a></span>
        {% highlight yaml %}- uses: crystal-lang/install-crystal@v1{% endhighlight %}
        <a href="https://github.com/crystal-lang/install-crystal" class="info">{% include icons/info.svg %}</a>
      </div>
    </div>
  </div>
  <div class="install-group">
    <h5>Community</h5>
    <div class="install-entries">
      <div class="install-entry">
        <span class="title">devenv.sh</span>
        {% highlight nix %}languages.crystal.enable = true{% endhighlight %}
        <a href="https://devenv.sh/reference/options/#languagescrystalenable" class="info">{% include icons/info.svg %}</a>
      </div>
    </div>
  </div>
</div>

## Nightly builds

<a href="nightlies">Instructions</a>

<a id="from_source"></a>

## Building from Source

The Crystal compiler is self-hosted, so in order to build it you need a Crystal compiler.
Hence from source installation is not an ideal way to get Crystal in the first place.
However it is possible to bootstrap from a different platform through cross-compiling.

<a href="from_sources">Instructions</a>

## Getting Started

<a href="https://crystal-lang.org/reference/getting_started/">Get Started</a>

<a href="https://repology.org/project/crystal-lang/versions">Crystal on Repology</a>
