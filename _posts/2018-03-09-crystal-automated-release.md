---
title: "Crystal Automated Release"
author: bcardiff
description: "How the build process was updated and what else can be done"
---

# Intro
As we shared at [the end of 2017](https://crystal-lang.org/2017/12/19/this-is-not-a-new-years-resolution.html), we restarted this year working on a plan towards 1.0. Our first stop was improving the automation of releases. Thanks to the [donations](https://salt.bountysource.com/teams/crystal-lang) of December and part of January, we managed to put 80 hours of work into this. Thanks as usual for the help!

# How things used to be
For a long time, we managed Crystal’s release and distribution process through  [omnibus-crystal](https://github.com/crystal-lang/omnibus-crystal). Even though parts of the process were automatic, it involved many manual steps that required  launching virtual machines for different distros to generate pkg, deb, tar.gz, etc.

This process used to be enough for our needs, when only one or two people (Ary and Waj) would be in charge of releasing versions of the language. But as the project and the core team grew, we were afraid that some parts of the process were not properly documented, depending on information sitting in their heads or work-of-art environments in their machines.

Another important part of the release process is publishing the docs in the website. Up to now, we’ve been doing this with Travis. Whenever we tagged a build,  we would have Travis sync the output of the `docs` command to S3. Then with some route redirect logic we would ensure that links to the latest release docs such as `/api/Array.html` would redirect to `/api/0.24.1/Array.html`, so we could use the former in articles or the Crystal book.

Then there’s Docker. Nowadays a release that doesn’t include an official Docker image seems off. So after building and publishing the packages for each platform a Docker image is built, tagged, and published to [https://hub.docker.com/r/crystallang/crystal/](https://hub.docker.com/r/crystallang/crystal/). Yet again this was not automated, and we sometimes would even forget to do it for a couple of days.

One last piece of the puzzle in this build madness is that the CI currently runs in Travis for Linux and Linux 32 bits using a Docker image to build the compiler while we rely on CircleCI for Mac builds. As a side note, the Docker images used in the CI are not updated automatically during the release build.

Despite all this manual process, @waj, @asterite, @jhass, @matiasgarciaisaia have done a great job to keep things moving forward.

Some releases ago, @RX14 wrote a new build process to improve the packages for some Linux distros. As a result, we decided to drop omnibus in favor of a multi stage Docker image to ship a compiler with musl and an up to date LLVM version when possible.

# What we want?
Our main goals are

1. Fully automate the process of building released binaries, including the provisioning of the machine where they are built.
2. Smoothen the release process to release more often and painlessly.
3. Test continuously to discover breakages in the ecosystem (including the most popular shards such as DB, Kemal, Amber, Lucky, etc) before the actual release.
4. Have unified release scripts (for our own sanity).

While trying to accomplish those goals we wanted to also address some technical debt regarding CI in general:

1. Move all platforms CI to a single CI environment.
2. Avoid manual post release steps like publishing Docker images for CI.
3. Update and unify versions of dependencies when possible.

# What we did and what “surprises” we found?

## Hello CircleCI 2.0

We migrated from a  CI setup that was running on CircleCI 1.0 to test OSX only to a CircleCI 2.0 workflow that will stress Linux32, Linux64 and OSX builds. Changing a cloud CI configuration it’s always a slow task: it feels like you send a script by email, then wait in queue, fail (many times) for silly details you missed, and retry once and again.

## Nightly for Linux 64 bits

After migrating the scripts that were running the CI we started to work on producing automated nightly images of the compiler for all supported platforms up to date.

To build Linux 64 bits we now use the new [distribution-scripts](https://github.com/crystal-lang/distribution-scripts) created by @RX14. Moving to this was almost completely straightforward, except for some changes needed because the only time we had used those scripts was to release the 0.24.1 compiler based on 0.23.1 (in case you were wondering, 0.24.0 was effectively yanked).

## Nightly for OSX

To build the osx compiler we migrated the [omnibus-crystal](https://github.com/crystal-lang/omnibus-crystal) repo to [distribution-scripts](https://github.com/crystal-lang/distribution-scripts). Having a single repo will simplify things eventually. We needed to tweak a bit how things used to be in order to avoid spending too much time of CircleCI [^update-ruby].

Eventually, we could get completely rid of omnibus, but the main goal was to automate the process rather than changing the packaging.

## Nightly for Linux 32 bits

The `distribution-scripts` build system produces `x86_64` Linux packages. To get 32 bits there were a couple of alternatives.

1. Use omnibus scripts as we used to, but run them in [somewhat official Docker i386 images](https://github.com/docker-library/official-images#architectures-other-than-amd64) instead of 32bits VMs since CircleCI does not provide 32 bits machine executors. Given that we are keeping the omnibus script for a little longer this seems like an easy path.
2. Make a version of distribution-scripts that will build a 32 bits compiler from a previous 32 bits compiler.
3. Make a version of distribution-scripts that will build a 32 bits compiler from a previous 64 bits compiler and perform a cross-compilation somewhere in the middle.

Doing 2 or 3 would change the packaging, and align the changes of the path introduced in the 64 bits current version. But would require a bit more effort than option 1.

So we tried option 1. The result was - we hit [a bug in Boehm's GC](https://github.com/ivmai/bdwgc/issues/133) specific to 32-bit Docker containers, that was fixed in a release newer than the one our Omnibus setup was using.

So we couldn't use Crystal 0.24.1 (with the buggy GC version) inside the Docker containers.  As a consequence, we built Crystal 0.24.2 for 32 bits manually, with a newer GC version. That will allow us to release 0.25.0 using the `distribution-scripts` in the future. Probably still sticking to option 1.

The bottom line: there are no 32-bit nightly packages for  0.24.2, but we should be able to introduce them in the future.

## Nightly for Docs

Including the docs in the process is also neat. And it lets us stop publishing from Travis automatically (for tags and branches). This way now we are all able to preview nightly/tagged docs, jump to old unpublished versions and, most importantly, publish docs to the main site at the same time the packages will be published and not just when tagging the repo. This caused some confusion in the past because going to the site would say some things but packages would not reflect them.

## Nightly for Docker

We wanted to go an additional step further and simplify how users could check if the nightly builds are working on their projects. So we put some work to publish Docker images tagged as nightly. With the fresh Linux packages made during the build we could install it and push a Docker image directly from CircleCI even if the package was not yet published in an APT repository. Note that these images have a compiler with release optimization, so the only difference with the official release will be the version description (of course, as long as the nightly built is performed on the same commit).

We are going to publish `crystallang/crystal:nightly` and `crystallang/crystal:nightly-build` Docker images. The former should be able to compile apps that use the stdlib, the latter includes LLVM and dependencies needed to build the compiler.

## Keep the lineage in the compiler repo

Each time a new Crystal compiler is released, the next one is usually built on the new one. The distribution and packaging solution usually will remain unchanged. In order not to lose track of the lineage of compilers it would be great to track exactly how each tag was built in the very same repository of the compiler. To accomplish this we made the distribution-scripts receive parameters to setup which existing Crystal compiler should be used to build the specific new commit or tag.

The Crystal repo now includes a reference to a specific release of the distribution-scripts to use for nightly builds. Since the information about the previous compiler is stated now in the CI configuration, the lineage will be available in the repo itself from now on. A bonus point is that different branches in the future will not be constrained to use the “latest” version.

## Tagged release build

The process of building a tagged commit is mostly the same. That is good! It’s the exhibit of a smoother build process.

Once CircleCI built distribution packages and docs what follows is:

1. Download the artifacts from CircleCI build.
2. Sign the packages.
3. Publish to repository.
4. The docs need to be uploaded to S3 and the new directory is flagged as latest. Essentially the same that was done in Travis up to now, but triggered as a whole when publishing the packages.
5. Build a docker image with the signed package and uploaded it.

These steps are performed manually using [crystal-lang/crystal-dist](https://github.com/crystal-lang/crystal-dist) so the signing keys are kept safe. Eventually this repo might be join with `distribution-scripts` so all the pieces are kept in a single place.

## Ecosystem tests

Nowadays, between Docker, Vagrant, CIs and other resources it’s possible to automate some smoke tests. We did some of this while releasing 0.24.1 and discovered some issues in the release before distributing it. But, sadly, we discovered those issues after tagging. With nightly packages available and some improvement in the tagging process we expect to run some smoke tests before releasing. This would help us detect problems earlier, maybe submitting PR/issues to the affected repositories. Although the compiler and the stdlib have a good amount of specs, for sure there are some interesting scenarios out there in the wild.

Today, we use [these ecosystem tests](https://github.com/bcardiff/test-ecosystem) to check (on Darwin, Linux, and Linux32) that some basic commands can be run, stacktraces work, crystal-db and drivers work, and the web frameworks Amber, Lucky and Kemal are able to work.

It’s not perfect, but it is an effort to at least know beforehand that something could be broken for the upcoming release.

# How will we do things from now on?
Let’s recap, what happens every night and for a proper release.

Every night on master and every time a commit is tagged the following workflow will be executed.

<img src="/assets/blog/crystal-ci-workflow.png" class="center"/>

That will roughly automatically:

1. Run specs
2. Build nightly branded packages
3. Build docs
4. Build Docker images from unsigned packages
5. Leave a copy of artifacts to be downloaded

Before tagging a commit with the next version, e.g.: `0.25.0` we want to ensure that the commit to be tagged is in good shape. If the nightly was performed in that commit we are ok, but a fail safe approach is to tag `0.25.0-pre1` and wait for the above mentioned steps.

Once the smoke test success the artifacts of `0.25.0-pre1` (or `-pre{N}`) we are good to tag `0.25.0`.

We proceed to sign the packages and publish them together with docs and tagged docker images with a single command. For the docker images a new `crystal:{version}-build` image will also be published to mimic the nightly -build ones.

There are two pending manual steps:

1. Update the homebrew formula
2. Update the ci scripts to build the next compiler from the just released one.

Well, there are still a couple of things more to improve and get done. It never ends! Check the following section.

# Automated Release Backlog

* Update distribution-scripts to emit 32 bits binaries so the binary creation is fully automated.
* We should be able to use the new Docker {version}-build images in the CI. That will remove the extra dependency of [jhass’ crystal build images](https://github.com/jhass/crystal-build-docker) that ran the CI until now.
* Move the manual build steps for publishing docker image with the signed packages and the publishing of the docs into jobs in circleci. These jobs will remain on hold waiting for a [manual approval](https://circleci.com/blog/manual-job-approval-and-scheduled-workflow-runs/) signaling that the packages were signed and published.
* There is some cleanup to do regarding dockerfiles and vagrantfile in the compiler repo. These are most probably outdated and some former use cases have changed.
* A proper nightly repo for Linux distributions would be great. There is one that is mainly used by Travis to allow `crystal: stable` and `crystal: nightly` options. In the future it would be great to automate updates on a nightly repo directly from the CI.
* We still haven’t updated the LLVM version used in the release process for OSX. Currently a custom LLVM 3.9.1 is embedded so the shipped binaries are a bit smaller. But for historical reasons before LLVM 3.8 we were forced to custom build to use some edge features. Maybe we could switch to official LLVM releases now. We are now using LLVM precompiled by 3rd parties for Linux since we started drifting from omnibus. If you use OSX you might notice that your LLVM uses 4.0 or 5.0 because probably you installed Crystal from Homebrew. That compiler is built by Homebrew and they use the latest stable release.
* The creation of a patch of Homebrew formula could be automated so submitting a PR for the new release could be really fancy and, more importantly, unforgettable.
* Shipping the compiler for more platforms is something that can be done, but as long as it can be automated. Eventually something that would make sense is to ship one version of the compiler that could be used to create packages for the different distros and use when possible native packages. That way the Crystal compiler package of each distro could be smaller and would play well regarding how dependencies need to be declared [^distro-deps]

# Next steps

Our next goal is to research on improving the compiler's performance. For that, we will be making a pass on language semantics to round off some of the known problems we know are there. That will allows us to solidify the language so that we can guarantee no breaking-changes post 1.0.
We have 41 hours left from January and 64 hours from donations received during February that we’ll invest during March on this. Please continue to [support our work](https://salt.bountysource.com/teams/crystal-lang), it makes a huge difference!

[^update-ruby]: the Ruby versions available in OSX CircleCI VMs are limited. Installing & building a specific Ruby version takes some time [https://discuss.circleci.com/t/cache-of-installed-ruby/19606](https://discuss.circleci.com/t/cache-of-installed-ruby/19606)
[^distro-deps]: [https://github.com/crystal-lang/crystal/issues/5650](https://github.com/crystal-lang/crystal/issues/5650)

