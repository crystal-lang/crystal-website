---
title: 'Using CircleCI 2.0 for your Crystal projects'
author: bcardiff
description: "An up to date article showing how to use CircleCI 2.0 for your Crystal projects."
---

It’s been a while since we wrote [Using CircleCI for your Crystal projects](https://manas.tech/blog/2016/06/13/using-circleci-for-your-crystal-projects/). Since then the following things happened:

* [CircleCI 2.0](https://circleci.com/docs/2.0/) was announced and 1.0 is deprecated.
* Crystal build process is partially [automated in CircleCI](/2018/03/09/crystal-automated-release.html)
* Docker nightly images are pushed as `crystallang/crystal:nightly` to Docker Hub
* Shards added a cache to avoid downloading from scratch dependencies

It’s time to review how to take advantage of the awesome features in CircleCI, to ensure your application or shard is up to date not only with the current Crystal release, but with the upcoming one. Doing this helps to detect early unwanted breaking changes in your dependences or, at least, be ready to release earlier.

As a case study, we will use a fake app that requires a database. The final example will cover a couple more of the basic needs and show a more realistic scenario.

# Using Crystal latest release for builds

You probably use `$ shards` to install dependencies of your application and `$ crystal spec` to run specs.

In order to do that in CircleCI using the latest release of Crystal you need to create a `.circleci/config.yml` with the following content.

```yaml
version: 2

jobs:
  test:
    docker:
      # Use crystallang/crystal:latest or specific crystallang/crystal:VERSION
      - image: crystallang/crystal:latest
    steps:
      - run: crystal --version

      - checkout

      - run: shards

      - run: crystal spec

workflows:
  version: 2
  ci:
    jobs:
      - test
```

It will show the specific compiler version used thanks to `crystal --version`. And you can force a specific version using `crystallang/crystal:VERSION` docker images instead of `crystallang/crystal:latest`.

# Using a database server

In your development environment you either have a database server installed or use docker and have probably mapped the ports to your host. So either way, if you use MySQL you can access the service as `localhost:3306`.

In CircleCI you can use [multiple docker images](https://circleci.com/docs/2.0/executor-types/#using-multiple-docker-images) and the ports of the additional images will be mapped to the first container. Pretty much as if the service would have been installed locally.

Adding the `mysql:5.7` image with some environment configuration and giving it some time to start property should be enough. The resulting config is as follows:

```yaml
version: 2

dry:
  wait_for_db: &wait_for_db
    name: Wait for MySQL
    command: sleep 7

jobs:
  test:
    docker:
      # Use crystallang/crystal:latest or specific crystallang/crystal:VERSION
      - image: crystallang/crystal:latest
      - image: mysql:5.7
        environment:
          MYSQL_DATABASE: 'sample_app'
          MYSQL_ALLOW_EMPTY_PASSWORD: 'yes'
    steps:
      - run: crystal --version

      - checkout

      - run: shards

      - run: *wait_for_db

      - run: crystal spec

workflows:
  version: 2
  ci:
    jobs:
      - test
```

**Note:** The `dry` key is not standard. It’s just a placeholder of values that will be used multiple times later or that helps reading the job’s steps. If prefered, you can inline their contents directly.

# Reduce CI delays

CircleCI caches docker images in each host and it even provides some [additional features](https://circleci.com/docs/2.0/docker-layer-caching/) to reduce downloading and building docker images. This greatly reduces the time spent in each build.

Another source of delay is downloading dependencies from scratch in every build. There are [solutions](https://circleci.com/docs/2.0/caching/#full-example-of-saving-and-restoring-cache) to store some files on a build to be used on a subsequent ones.

Adding steps to save and restore the path used as `SHARDS_CACHE_PATH` allows the build to run faster.

```yaml
version: 2

dry:
  restore_shards_cache: &restore_shards_cache
    # Use {% raw %}{{ checksum "shard.yml" }}{% endraw %} if developing a shard instead of an app
    keys:
      - {% raw %}shards-cache-v1-{{ .Branch }}-{{ checksum "shard.lock" }}{% endraw %}
      - {% raw %}shards-cache-v1-{{ .Branch }}{% endraw %}
      - shards-cache-v1

  save_shards_cache: &save_shards_cache
    # Use {% raw %}{{ checksum "shard.yml" }}{% endraw %} if developing a shard instead of an app
    key: {% raw %}shards-cache-v1-{{ .Branch }}-{{ checksum "shard.lock" }}{% endraw %}
    paths:
      - ./shards-cache

  wait_for_db: &wait_for_db
    name: Wait for MySQL
    command: sleep 7

jobs:
  test:
    docker:
      # Use crystallang/crystal:latest or specific crystallang/crystal:VERSION
      - image: crystallang/crystal:latest
        environment:
          SHARDS_CACHE_PATH: ./shards-cache
      - image: mysql:5.7
        environment:
          MYSQL_DATABASE: 'sample_app'
          MYSQL_ALLOW_EMPTY_PASSWORD: 'yes'
    steps:
      - run: crystal --version

      - checkout

      - restore_cache: *restore_shards_cache
      - run: shards
      - save_cache: *save_shards_cache

      - run: *wait_for_db

      - run: crystal spec

workflows:
  version: 2
  ci:
    jobs:
      - test
```

Notice how the cache key involves the checksum of the content of `shard.lock`. If you are using this for a shard, there should be no `shard.lock` file checked in and the `shard.yml` should be used instead.

# Checked code against Crystal nightly

Crystal keeps evolving and, while the ecosystem is still growing, some dependencies may or may not need to be updated on every release. Some shards don’t have constant commit activity and CI usually runs on every push and PRs. This leads to the possibility of not running specs while the compiler and the std libs are still evolving and might break.

We can mostly duplicate the definition of the `test` job and execute it against `crystallang/crystal:nightly` image and schedule that run every single UTC night. Maybe, since crystal nightly starts at UTC night, it would be good to wait a bit, either way running `crystal --version` in build seems a good idea to do.

The shards cache can be used for nightly builds but there is no gain in saving it.

So a not so minimalistic CircleCI config for a real app with dependencies, shorter build times and regular checks with Crystal nightly releases could be as follows:

```yaml
version: 2

dry:
  restore_shards_cache: &restore_shards_cache
    # Use {% raw %}{{ checksum "shard.yml" }}{% endraw %} if developing a shard instead of an app
    keys:
      - {% raw %}shards-cache-v1-{{ .Branch }}-{{ checksum "shard.lock" }}{% endraw %}
      - {% raw %}shards-cache-v1-{{ .Branch }}{% endraw %}
      - shards-cache-v1

  save_shards_cache: &save_shards_cache
    # Use {% raw %}{{ checksum "shard.yml" }}{% endraw %} if developing a shard instead of an app
    key: {% raw %}shards-cache-v1-{{ .Branch }}-{{ checksum "shard.lock" }}{% endraw %}
    paths:
      - ./shards-cache

  wait_for_db: &wait_for_db
    name: Wait for MySQL
    command: sleep 7

jobs:
  test:
    docker:
      # Use crystallang/crystal:latest or specific crystallang/crystal:VERSION
      - image: crystallang/crystal:latest
        environment:
          SHARDS_CACHE_PATH: ./shards-cache
      - image: mysql:5.7
        environment:
          MYSQL_DATABASE: 'sample_app'
          MYSQL_ALLOW_EMPTY_PASSWORD: 'yes'
    steps:
      - run: crystal --version

      - checkout

      - restore_cache: *restore_shards_cache
      - run: shards
      - save_cache: *save_shards_cache

      - run: *wait_for_db

      - run: crystal spec

  test-on-nightly:
    docker:
      - image: crystallang/crystal:nightly
        environment:
          SHARDS_CACHE_PATH: ./shards-cache
      - image: mysql:5.7
        environment:
          MYSQL_DATABASE: 'sample_app'
          MYSQL_ALLOW_EMPTY_PASSWORD: 'yes'
    steps:
      - run: crystal --version

      - checkout

      - restore_cache: *restore_shards_cache
      - run: shards

      - run: *wait_for_db

      - run: crystal spec

workflows:
  version: 2
  # Run tests on every single commit
  ci:
    jobs:
      - test
  # Run tests every night using crystal nightly
  nightly:
    triggers:
      - schedule:
          cron: "0 2 * * *"
          filters:
            branches:
              only:
                - master
    jobs:
      - test-on-nightly
```

That’s it! Thanks CircleCI for all the great features!
