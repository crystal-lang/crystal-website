---
title: Dependencies
description: >
  Crystal libraries are packed as Shards, and distributed via Git without needing a centralised repository. Built in commands allow dependencies to be easily specified through a YAML file and fetched from their respective repositories.
read_more: '[Read more about Shards in the repo](https://github.com/crystal-lang/shards)'
runnable: playground
weight: 6
---
```yaml
name: my-project
version: 0.1
license: MIT

crystal: {{ latest_release.version }}

dependencies:
  mysql:
    github: crystal-lang/crystal-mysql
```
