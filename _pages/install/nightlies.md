---
page_title: Nightly Builds
layout: page-wide
page_class: page--segmented
---

Nightly builds of the Crystal compiler are available from these locations.

## Linux

<div class="install-panels">
  <div class="install-group">
    <h5>Crystal</h5>
    <div class="install-entries">
      <div class="install-entry">
        <span class="title"><a href="../on_linux#installer" title="Instructions for Linux installer">Installer (DEB &amp; RPM)</a></span>
        {% highlight shell %}curl -fsSL https://crystal-lang.org/install.sh | sudo bash -s - --channel=nightly{% endhighlight %}
        <a href="https://build.opensuse.org/project/show/devel:languages:crystal" title="Crystal repository on OBS" class="info">{% include icons/info.svg %}</a>
      </div>
      <div class="install-entry">
        <span class="title"><a href="../from_targz/">Tarball</a></span>
        <p>
          Archive on <a href="https://artifacts.crystal-lang.org/dist/crystal-nightly-linux-x86_64.tar.gz">artifacts.crystal-lang.org</a>.
        </p>
      </div>
    </div>
  </div>
  <div class="install-group">
    <h5>Community</h5>
    <div class="install-entries">
      <div class="install-entry">
        <span class="title">Homebrew/<wbr />Linuxbrew</span>
        {% highlight shell %}brew install crystal --HEAD{% endhighlight %}
        <a href="https://formulae.brew.sh/formula/crystal" title="Crystal package on Homebrew" class="info">{% include icons/info.svg %}</a>
      </div>
      <div class="install-entry">
        <span class="title"><a href="../from_snapcraft/">Snapcraft</a></span>
        {% highlight shell %}snap install crystal --classic --edge{% endhighlight %}
        <a href="https://snapcraft.io/crystal" title="Crystal on Snapcraft" class="info">{% include icons/info.svg %}</a>
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
      <span class="title"><a href="../from_targz">Tarball</a></span>
        <p>Archive on <a href="https://artifacts.crystal-lang.org/dist/crystal-nightly-darwin-universal.tar.gz">artifacts.crystal-lang.org</a>.</p>
      </div>
    </div>
  </div>
  <div class="install-group">
    <h5>Community</h5>
    <div class="install-entries">
      <div class="install-entry">
        <span class="title">Homebrew/<wbr />Linuxbrew</span>
        {% highlight shell %}brew install crystal --HEAD{% endhighlight %}
        <a href="https://formulae.brew.sh/formula/crystal" title="Crystal package on Homebrew" class="info">{% include icons/info.svg %}</a>
      </div>
    </div>
  </div>
</div>

<a id="windows"></a>

## Windows (preview)

<div class="install-panels">
  <div class="install-group">
  <h5>Crystal</h5>
    <div class="install-entries">
      <div class="install-entry">
        <span class="title"><a href="../on_windows">Portable Archive</a></span>
        <p>
          Archive on <a href="https://nightly.link/crystal-lang/crystal/workflows/win/master/crystal.zip">artifacts.crystal-lang.org</a>.
        </p>
      </div>
    </div>
  </div>
  <div class="install-group">
    <h5>Community</h5>
    <div class="install-entries">
      <div class="install-entry">
        <span class="title"><a href="../from_scoop">Scoop</a></span>
        {% highlight powershell %}
scoop install git
scoop bucket add crystal-preview https://github.com/neatorobito/scoop-crystal
scoop install crystal-nightly{% endhighlight %}
        <a href="https://github.com/neatorobito/scoop-crystal" title="Scoop repository for Crystal on GitHub" class="info">{% include icons/info.svg %}</a>
      </div>
    </div>
  </div>
</div>

## Docker

Nightly builds are available on the `nightly` tag on the [Docker repository of Crystal](https://hub.docker.com/r/crystallang/crystal/).

<div class="install-panels">
  <div class="install-group">
    <h5>Crystal</h5>
    <div class="install-entries">
      <div class="install-entry">
        <span class="title">crystallang (x86_64)</span>
        {% highlight shell %}docker pull crystallang/crystal:nightly{% endhighlight %}
        <a href="https://hub.docker.com/r/crystallang/crystal/" title="crystallang's Crystal image on Docker Hub" class="info">{% include icons/info.svg %}</a>
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
        <span class="title"><a href="https://crystal-lang.github.io/install-crystal/">GitHub Actions</a></span>
        {% highlight yaml %}
- uses: crystal-lang/install-crystal@v1
  with:
    crystal: nightly{% endhighlight %}
        <a href="https://github.com/crystal-lang/install-crystal" class="info">{% include icons/info.svg %}</a>
      </div>
    </div>
  </div>
</div>

## From Sources

See [*Build from sources*](../from_sources) for further instructions and pull the content of the `master` branch, instead of a tagged release version.
