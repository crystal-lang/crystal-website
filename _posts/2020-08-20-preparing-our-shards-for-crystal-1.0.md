---
title: Preparing our shards for Crystal 1.0
summary: How we can prepare our shards for Crystal 1.0 or for upstream changes of dependencies at any time.
thumbnail: +
author: bcardiff
---

A shard always has one or more dependencies. These dependencies are subject to change. The author might be more or less conservative regarding any breaking-changes. I want to revisit what are the mechanisms to check if the shard we are working on is up to date with the upcoming changes of its dependencies.

Of course, the process described here is a bit opinionated. Depending on the release process of your shard and the branching scheme used, some things might need a little tweaking. Nonetheless, I think it is valuable to revisit at least one alternative to do it.

When I say that the shard always has at least one dependency it is because the std-lib, and the language, act as yet another dependency.

# Version checks

As dependencies evolve, it is up to you to decide whether to support just the latest release and force everybody to be on edge, or to support some older versions.

Thanks to the built-in reflection macros and methods as `has_constant?`, `has_method?`, `responds_to?`, etc., we can have code that compiles and works on multiple versions of a dependency.

One other mechanism that is not as fancy, but simple, is the `compare_versions` macro. If `AwesomeDependency` defines a `AwesomeDependency::VERSION` (as it is encouraged by the init template), then `{% raw %}{% if compare_versions(AwesomeDependency::VERSION, "2.0.0") >= 0 %}{% endraw %}` is available to use features only on 2.0.0 or later releases.

## Advertised version

If the 3.x version of AwesomeDependency is being developed, we encourage you to set `AwesomeDependency::VERSION` to `"3.0.0-dev"` or something alike. `"3.0.0"` may be good enough, but some prefer to keep that value for the tagged release only.

If the `AwesomeDependency::VERSION` is not increased _during_ the development of 3.x and is kept as the latest 2.x release, then it will be impossible to use `compare_versions` to check for 3.x.

If `AwesomeDependency::VERSION = "3.0.0-dev"` and we want to start supporting that version in our development branch, we will need to use something like `{% raw %}{% if compare_versions(AwesomeDependency::VERSION, "3.0.0-0") >= 0 %}{% endraw %}`, with a trailing `-0`. This is because `3.0.0-0 < 3.0.0-a < 3.0.0-dev < 3.0.0-z < 3.0.0`.

# Declaring dependencies

At this point, we need to mention how dependencies can be declared. As mentioned before, on a tagged release, the `shard.yml` acts as a contract. This contract states what are the supported versions of each dependency. Shards allows us to declare dependencies, not only as version ranges, but also on a branch, or with no version. Still, I would recommend using version ranges, with lower and upper bound versions, on every formal release of a shard. The other variations should be limited to applications with a `shard.lock` or work in progress.

My recommendation is that dependencies are declared as:

- `~> 0.9.2` (ie: `>= 0.9.2, < 0.10`) for 0.x versions dependencies, since the next minor release can have breaking changes.
- `~> 2.2` (ie: `>= 2.2, < 3.0`) for non 0.x dependencies where any patch level would work.
- `~> 2.2, >= 2.2.3` (ie: `>= 2.2.3, < 3.0`) for non 0.x dependencies where at least certain patch is required. Potentially, this could be the current patch version if you want.
- `>= 2.2.3, < 5.0.0` for cases where you want to support a wide range of versions.

Note that `~> 0.9`, without a patch number, is `>= 0.9, < 1.0`. This might be too optimistic for a 0.x dependency, so I would discourage it.

You might be tempted to say _any version is fine_ but: Did you check older versions to honor that contract? Are you sure that future versions will be supported? Each dependency might be different: in some cases you might be able to feel more secure about this, depending on the author, maintainer and scope of the shard.

Assuming we are on board with having the above recommendations on the tagged releases of our shard, we can move on to the next topic: How can we check our shard against upcoming or recently released versions of our dependencies.

My pick is to have the supported versions of the dependencies in the `shard.yml` of the development branch. That is, exactly as they will be published upon release.

Thanks to [shards override feature](https://github.com/crystal-lang/shards/pull/422) in [Shards v0.12](https://crystal-lang.org/2020/08/06/shards-0.12.0-released.html) we can have a `shard.edge.yml` file were we can force the usage of the development branch of `AwesomeDependency`, locally or on a CI, and use the `compare_versions` or other mechanism to check against unreleased changes of that dependency.

We can also have multiple overrides files if we want to check individual dependencies.

If this mechanism is used with a cron on the CI we will have nightly checks of the dependencies.

Another alternative would be to set version ranges on dependencies only when releasing our shard. This would leave unrestricted dependencies in our development branch, but I think that that will require more work upon release, and it will still require the override to avoid picking the latest release by default.

# Moving to Crystal 1.0

So far we haven’t mentioned Crystal 1.0. What's the deal with this release or any other major releases? The shards out in the wild declare which std-lib and language version they work with.

The `crystal:` property in the `shard.yml` declares this. Out in the wild, almost every shard has an implicit `< 1.0` right now. When using `crystal: x.y[.z]`, it is interpreted that the shard will work with `~> x.y, >= x.y.z` (ie: `>= x.y.z, < (x+1).0.0`) of the std-lib and language version. This is the same as one of the previously suggested version restriction patterns.

As with any dependency, we are free to state that any crystal version will work with our release `crystal: *`, or remove the upper bound `crystal: > 0.35`. But again, how can you be sure of that claim?

Up until now, checking if a shard can work with the upcoming Crystal release required us to use a Crystal nightly build. We still need to do this, but the Crystal nightlies release has a `1.0.0-dev` version currently.

Since the Crystal version we are using is `1.0.0-dev`, shards out in the wild are not candidates. And it is possible that they won’t be available until a 1.x tag is released. How could that be?

To avoid locking us in this, or other major Crystal release, the `--ignore-crystal-version` Shards option can be used. It will not be needed when migrating from Crystal 1.0 to 1.1, but it will come handy again when Crystal 2.0 is developed.

You can set the `SHARDS_OPTS` environment variable to `--ignore-crystal-version` in your CI if the `shards install` command is performed implicitly along the way.

# Preparing all the ecosystem for Crystal 1.0

Let's revisit the whole state with a more concrete hypothetical (and pessimistic) example. We are the authors of `BelovedShard` that depends on `AwesomeShard`. So far everything is working on Crystal 0.35. `BelovedShard` is in `1.5.0` and `AwesomeShard` is in `2.2.3`.

```yaml
# BelovedShard's shard.yml file
name: beloved_shard
version: 1.5.0
dependencies:
  awesome:
    github: acme/awesome_shard
    version: ~> 2.2
crystal: 0.35
```

<br/>

```yaml
# AwesomeShard's shard.yml file
name: awesome_shard
version: 2.2.3
crystal: 0.35
```

When trying to use Crystal 1.0.0-dev on `BelovedShard`, we might stumble onto some issues with `AwesomeShard` and we might not be a maintainer of it. Thanks to Shards override you can fork and change the source of the awesome shard to it.

Whether the Awesome fix is done in the main repo, or in a fork, or in the development branch, or in a `crystal/1.0` branch, it does not make too much of a difference. All this information will be stated in the shard override file.

The important question is: Which Crystal versions will the next version of Awesome support: `>= 1.0, < 2.0` or `>= 0.35, < 2.0`? This should guide us when changing the `crystal:` property in the `shard.yml`, and also tell us if we need to use `compare_versions(Crystal::VERSION, "1.0.0-0")` or not.

Changing the `shard.yml` is not required right from the start. This can be delayed thanks to `--ignore-crystal-version`, but it is a good practice to have a clear idea of what the goal is for that property, since it affects the code to be written.

Let's suppose that AwesomeShard was fixed for Crystal 1.0.0-dev in it's development branch. It will support 1.0 only upon release, but for now `crystal: 0.35` is still there, since it might want to release a `2.2.4` patch before Crystal 1.0 is released. This means that changes to Awesome use `compare_versions` and sometime, after Crystal 1.0 is released, those checks will go away and drop support for 0.35.

More importantly, this means that the development branch of Awesome _should_ work with Crystal 1.0.0-dev.

Now let's focus on BelovedShard where we want the same: the development branch should work with Crystal 1.0.0-dev. But we don’t want to wait for Awesome to be released.

In our CI (or sometimes locally) we can use the following setup to accomplish that:

```yaml
# BelovedShard's override file shard.edge.yml
dependencies:
  awesome:
    github: acme/awesome_shard
    branch: develop
```

Set `SHARDS_OPTS=--ignore-crystal-version` and `SHARDS_OVERRIDE=shard.edge.yml`.

This will make the `shards install` command use the development branch of Awesome, and it will not complain about the Crystal version mismatch (we are running a Crystal 1.x, but shard.yml in awesome states `>= 0.35, < 1.0`).

While changing BelovedShard we might need to `compare_versions(Crystal::VERSION, "1.0.0-0")` and `compare_versions(Awesome::VERSION, "2.3.0-0")`. But our development branch is able to move forward and stay up to date with Crystal and Awesome. Awesome!

While Crystal 1.0.0-dev keeps evolving, we can iterate on both shards.

Once Crystal 1.0 is released, each shard will make the explicit decision about which version of the std-lib and language is supported. This will trigger changes in the `shard.yml` and maybe some code clean-ups.

# Closing thoughts

There are other workflows to keep things up to date. This is just one option.

As a community, other patterns might appear or be preferred in the long run. The recent changes in Shards aimed to provide at least one option that works and can be adapted to some extent.

