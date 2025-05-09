---
short_name: Shards
title: Dependencies
description: |
  Crystal libraries are packed with *Shards*, a distributed dependency manager without a centralised repository.

  It reads dependencies defined in `shard.yml` and fetches the source code from their repositories.
read_more: '[Read more about Shards](https://crystal-lang.org/reference/latest/man/shards)'
runnable: playground
---
```yaml
name: hello-world
version: 1.0.0
license: Apache-2.0

authors:
- Crys <crystal@manas.tech>

dependencies:
  mysql:
    github: crystal-lang/crystal-mysql
    version: ~>0.16.0
```
