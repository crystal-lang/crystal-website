---
title: Snapcraft Summit Montréal
summary: Updates in Crystal distributions and other news
author: bcardiff
---

The [Snapcraft Summit Montréal](https://snapcraft.io/blog/snapcraft-summit-montreal) took place between June 11th and June 13th, 2019 and people from different open-source projects gathered to iterate and work in a flawless manner, that would have taken far more time and resources if it wasn't for the summit. The shared goal was to improve the presence of each individual project in the [snapcraft.io](https://snapcraft.io) store. The plus side of the story was being able to meet the people behind different projects and share past experiences and current ideas.

Day by day, there were steady updates for the projects. Some were not new to the platform and sought improvements and problem solving. Others learnt about the confinement capabilities, the different pieces that make the store come to life, and take the first steps towards integrating them. At the end of each day a massive status check of almost forty parties was held, and a summary was dropped in [forum.snapcraft.io](https://forum.snapcraft.io/t/snapcraft-summit-montreal-2019-day-1-2-3/11763).

Before jumping into the technical changes for Crystal itself, I would like to mention the people with whom I shared some chats, ideas and work that definitely can impact in future proposals. These people are [Daniel Silverstone](https://twitter.com/dsilverstone) from **rustup**, [Ana Rosas](https://twitter.com/ana_rosas) & [María de Antón](https://twitter.com/amalulla) from **TravisCI**, [Alex Arslan](https://github.com/ararslan) & [Jeff Bezanson](https://twitter.com/jeffbezanson) from **Julia**, [Graham Christensen](https://twitter.com/grhmc) from  **NixOS**, and [Sergio Schvezov](https://twitter.com/sergiusens) from **Snapcraft**. Meeting them helped me get to know better some aspects of the projects, challenges, and solutions that are not in clear sight. I can't stress enough how much I enjoyed meeting them all.

## What's new?

1. Crystal has a new official distribution method in [snapcraft.io/crystal](https://snapcraft.io/crystal) that applies to 10 Linux distros (and counting...)
2. Crystal applications can be packaged and distributed as snaps.
3. Nightly native packages have now a straightforward way to be installed.
4. TravisCI is using the above method when `crystal: nightly` is specified.

## Crystal snap

You can jump and find the snap installation instructions in the new shinny [snapcraft.io/crystal](https://snapcraft.io/crystal) page.

The store has the notion of channels, which helps support the release process with *edge*, *beta*, *candidate*, and *stable* versions.

The CI script has been updated to publish the content of *master* to the edge channel every night. So now nightlies are available there, as well as in `crystal-lang/crystal:nightly` docker image, and in the artifacts of the build itself.

Upon tagging and releasing a new version, the package will be available also in the edge channel and will be moved to the stable channel manually. For now, beta and candidate channel are not expected to be used, but the ability to do so in the future is great.

Since the Crystal snap runs in the *classic* confinement level (more about this later), the installation from the terminal in Ubuntu package is:

<div class="code_section">{% highlight shell %}
$ sudo snap install crystal --classic        # For stable releases
$ sudo snap install crystal --edge --classic # For nightly releases
{% endhighlight crystal %}</div>

## TravisCI integration

Travis needs to deal with a lot to support the different languages and configurations. Having a more unified way to install them, considering also the new upcoming releases, would definitely simplify their human and computer workload.

Travis was eager to start giving support to languages through snaps, and we were eager to reestablish the availability of nightlies.

<blockquote class="twitter-tweet"><p lang="en" dir="ltr">Working on bringing back <a href="https://twitter.com/CrystalLanguage?ref_src=twsrc%5Etfw">@CrystalLanguage</a> nightlies in <a href="https://twitter.com/travisci?ref_src=twsrc%5Etfw">@travisci</a> with <a href="https://twitter.com/ana_rosas?ref_src=twsrc%5Etfw">@ana_rosas</a> at <a href="https://twitter.com/hashtag/snapcraftsummit?src=hash&amp;ref_src=twsrc%5Etfw">#snapcraftsummit</a> powered by <a href="https://twitter.com/snapcraftio?ref_src=twsrc%5Etfw">@snapcraftio</a> <a href="https://t.co/ayQum84Nbm">pic.twitter.com/ayQum84Nbm</a></p>&mdash; Brian J. Cardiff (@bcardiff) <a href="https://twitter.com/bcardiff/status/1138905956933414912?ref_src=twsrc%5Etfw">June 12, 2019</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

[From now on](https://changelog.travis-ci.com/crystal-nightlies-support-105460), when using `crystal: nightly` in the `travis.yml` file, the snap in the edge channel will be used. For a couple of months the `crystal: latest` will still use the current `.deb` packages that are hosted in our package repository. Eventually, the snap in the stable channel will be used.

A bonus point is that our package repository will not get traffic from CI builds.

## Packaging your Crystal app as a snap

Once [snapcraft#2598](https://github.com/snapcore/snapcraft/pull/2598) ~~is merged and released~~ (Edit: it was been released in Snapcraft 3.7!), building a snap that will package the application will be easy. If you are unfamiliar with snapcraft don't miss [its introduction](https://snapcraft.io/blog/introduction-to-snapcraft).

Assuming there is a `shard.yml` that declares targets, dependencies, etc.

<div class="code_section">{% highlight yaml %}
name: hello

targets:
  hello:
    main: src/hello.cr

# ... stripped ...
{% endhighlight yaml %}</div>

A basic `snapcraft.yaml` file to declare all the parts will look as follows:

<div class="code_section">{% highlight yaml %}
name: crystal-hello
version: "1.0"
summary: Create the hello snap
description: Create the hello snap

grade: devel
confinement: strict

apps:
  crystal-hello:
    command: bin/hello

parts:
  crystal-hello:
    plugin: crystal
{% endhighlight yaml %}</div>

After installing the generated snap, `$ crystal-hello` will invoke `./bin/hello`. Of course you can tweak the names and avoid the `crystal-` prefix.

When building the `.snap` the following things will happen:

1. Installing dependencies via `$ shards install --production`.
2. Building all targets via `$ shards build --production`.
3. Packaging all executables in `./bin` in the final `.snap`.
4. Packaging all linked libraries required to run those binaries (detected via `ldd`)

In case the app requires some C libraries that are not available by default, you will need to list them as [build-packages](https://docs.snapcraft.io/t/build-and-staging-dependencies/11451).

If you can't wait, you can grab the PR code and use it as a [local plugin](https://docs.snapcraft.io/writing-local-plugins).

## Some technical details of the crystal snap

While starting to develop the Crystal snap we try to make it work in the *strict* confinement. The challenge to make it work as strict is how to get libraries and toolchain of host and snap to coexist.

When installing a snap there is no package dependencies that can be declared (like in the `.deb` packages). So it would require to have all the libraries included by default in order to have a smooth fresh experience.

As soon as the program to compile becomes more advanced, or a shard library links against a C library, the user will need to deal with some abstraction leaks in packaging related to how those libraries are to be found.

That is the main reason why we stick to the *classic* confinement model. The caveat is how to let the user know that some native package of the Linux distribution needs to be available as a post-installation step.

[The current solution](https://github.com/crystal-lang/distribution-scripts/pull/39) is that the crystal command installed with the snap is actually a wrapper that checks the compiler can be used successfully for simple programs. A message regarding required packages is shown if something goes wrong with that check.

While working on this we push to perform some updates in CircleCI regarding its [snap](https://github.com/cibuilds/snapcraft/issues/1) [support](https://github.com/circleci/circleci-docs/pull/3441) and their response time was awesome.

## Version management

The store works with a concept called [channel](https://docs.snapcraft.io/channels). For each channel a single version is available. A channel full name is `<track>/<risk>/<branch>` where the default track is called *latest*.

As stated before, the most recent release will be available in the `latest/stable` channel, and nightlies in `latest/edge`. We have already set up the CI to be able to deliver some `latest/edge/<feature-branch>` on demand.

While crystal does not reach `1.0`, this schema is enough. You are able to access the latest stable release, _and_ the future version.

There were some discussions regarding how to handle explicit version availability in the store for projects following semver. The general consensus is to create a *track* for each `Major.minor` release, leaving only the latest `Major.minor.patch` available in the store. In this schema some projects might leave the `latest` track empty to force the user to make an explicit decision. What schema we will follow is still open.

<br/>

To Canonical, Travis CI, and all the people involved, thanks for an awesome week!
