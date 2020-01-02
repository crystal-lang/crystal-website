---
title: Introducing shardbox.org
summary: A platform for discovering the shards ecosystem.
author: straight-shoota
---

I'm happy to announce the launch of [shardbox.org](https://shardbox.org), a database for discovering shards.

To be clear: Shardbox is not a shards registry. It won't serve as part of shards' dependency resolution, which works entirely decentralized. It just collects information about publicly available shards and serves as a catalog for the shards ecosystem. It's a tool for developers to help find existing shards they might want to use.
If you're familiar with Ruby, think of it more like [The Ruby Toolbox](https://www.ruby-toolbox.com/) than [Rubygems](https://rubygems.org/).

There are already services providing a similar functionality such as [crystalshards.org](https://crystalshards.org/) or [shards.info](https://shards.info/). So why do we need another one?
The existing services work as a relatively simple wrapper around the GitHub API and don't maintain their own database. While being relatively easy to implement, this approach can't fully support the capabilities of shards and provide in-depth information about shards and the relations inside the ecosystem.

Most importantly, being focused on GitHub excludes any shards hosted elsewhere. Shardbox doesn't rely on any hosting provider and can work with any shard repository as long as it's publicly available. It can still use supplementary information provided by hosting providers, when available.

Shardbox collects information about shards and their relationships. This makes it easy to discover reverse dependencies and dependency graphs (shards.info has a basic implementation, but it's restricted to the capabilities of GitHub's search API), even for older releases.

When a repository is removed from GitHub, it doesn't just vanish from the Shardbox database. Information is kept even for shards that are no longer accessible. This can help recover otherwise lost information and it's possible to continue on when the repository becomes available at a different location. Any shard can have associated mirror repositories.

Shardbox offers a lot of additional features, such as taxonomy, data analysis, release histories, access to shard contents and domain-specific search features.

For the better part of 2019 I've been on-and-off working on this side project.
It is finally in a state that I think it works pretty well and provides useful information for everyone using and looking for shards.
I expect it to run without major disruptions, but it's not yet battle tested. Teething troubles may apply.

If you find any problems, don't hesitate to open a ticket at [the issue tracker](https://github.com/shardbox/shardbox-web/issues). Contributions for fixing bugs and feature enhancements are also very welcome. I already have a few ideas what would be nice to do next and I'm curious about your suggestions as well.
If you find a shard is missing from the database, you can add it to the catalog at [github.com/shardbox/catalog](https://github.com/shardbox/catalog). See [shardbox.org/contribute](https://shardbox.org/contribute) for more details.
