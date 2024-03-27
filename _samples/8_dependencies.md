---
short_name: Shards
title: Dependencies
description: |
  Crystal libraries are packed with *Shards*, a distributed dependency manager without a centralised repository.

  It reads dependencies defined in `shard.yml` and fetches the source code from their repositories.
read_more: '[Read more about Shards](https://github.com/crystal-lang/shards)'
runnable: playground
---
```yaml
name: my-first-crystal-app
version: 1.0.0
license: Apache-2.0

authors:
- Crys <crystal@manas.tech>

dependencies:
  mysql:
    github: crystal-lang/crystal-mysql
    version: ~>0.16.0

development_dependencies:
  ameba:
    github: crystal-ameba/ameba
```
