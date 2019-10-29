---
title: Split the repo!
summary: where the git...
thumbnail: G
author: bcardiff
---

Crystal is made of many parts. Some of them migrated to other repositories this week.

This will allow better organization, project infrastructure, and even better acknowledgement of contributions.

Lets do a quick review of some artifacts, projects and repos where you might want to contribute.

## Crystal compiler, std and tools

[crystal](https://github.com/crystal-lang/crystal) is of course where the compiler and the standard library reside, among other tools shipped with the compiler: init, docs, spec, format, play, etc.

## Dependency manager

[shards](https://github.com/crystal-lang/shards) is our dependency manager. That thing that allows you to use 3rd parties shards.

## Website

[crystal-website](https://github.com/crystal-lang/crystal-website) is a [jekyll](http://jekyllrb.com) project where posts are written, sponsors are listed and other public resources can be accessed at [crystal-lang.org](http://crystal-lang.org).

## Book

[crystal-book](https://github.com/crystal-lang/crystal-book) is a gitbook project that serves as introduction and manual to the language. After every commit in master a copy of the book is published in [/docs](https://crystal-lang.org/docs).

There have been already translations of many languages of the book: [ru](http://ru.crystal-lang.org/docs/), [br](http://br.crystal-lang.org/docs/), [ja](http://ja.crystal-lang.org/docs/), [tw](http://tw.crystal-lang.org/docs/). Thanks everybody for making crystal speak your language ♥.

Now that it is on its own repo it might be easier to keep changes up to date.

## API documentation

[api](https://crystal-lang.org/api/) is the reference documentation of crystal standard library. The source? Well, it is in the main [crystal repo](https://github.com/crystal-lang/crystal) like in [src/array.cr](https://github.com/crystal-lang/crystal/blob/master/src/array.cr).

If you jump to [/api/master/](https://crystal-lang.org/api/master/) you can view the reference for the code in master branch.

**TIP:** Did you know that for your own shard `crystal docs` will generate those nicely pages to describe it. So others will know how to use your shard. ♥
