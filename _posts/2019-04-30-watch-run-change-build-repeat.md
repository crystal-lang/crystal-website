---
title: "Watch: Run, change, build, repeat"
summary: How to improve the development cycle with a watch experience
thumbnail: W
author: bcardiff
---

In this post, we'll cover how to automatically recompile and execute your code when you modify your source files. This technique can be applied easily on apps ranging from a CLI app, to a full web server.

## Requirements

* Have `watchexec` installed (check [github](https://github.com/watchexec/watchexec) for installation instructions)
* Use shards’ `targets`

## Setup

Create a `./dev/build-exec.sh` file with the following content. This is the script that will recompile and execute your code.

```shell
#!/bin/bash
cd $(dirname $0)/..
shards build "$1" && exec ./bin/"$1" "${@:2}"
```

Create a `./dev/watch.sh` file with the following content. This script will watch for changes to your source files and execute the build when there are any.

```shell
#!/bin/bash
cd $(dirname $0)/..
watchexec -r -w src --signal SIGTERM -- ./dev/build-exec.sh "$@"
```

Allow them to be executed:

```shell
$ chmod +x ./dev/build-exec.sh ./dev/watch.sh
```

## Enjoy

If you created your app with `$ crystal init app awesome_app`

There should be a target named `awesome_app`

```shell
$ cat shard.yml
name: awesome_app

... stripped ...

targets:
  awesome_app:
    main: src/awesome_app.cr
```

You can start running the app and watching for changes doing

```shell
$ ./dev/watch.sh awesome_app
```

And you can even pass arguments

```shell
$ ./dev/watch.sh awesome_app first second
```

## How does it work

The `build-exec.sh` file is taking advantage of the output location of a target to be able to build it and run it. But we want to run it in a special way: via `exec` we are replacing the current process with the new version of the program.

The `build-exec.sh` will be called with the target as a first argument and from the rest of the arguments will be the one we expect the application to receive. That is the role of `${@:2}`.

The `watch.sh` will keep an eye on the `./src` directory and if anything changes the `build-exec.sh` will be run while keeping the arguments.

A bonus point of the proposed `watch.sh` is that it politely requests the app to terminate via a `SIGTERM`.

## Take it to the next level

This solution can be adapted to be used in a docker container since `watchexec` works flawlessly with Docker’s bind mounted volumes.

You can make your specs run continuously, as long as you also watch `./spec` files.

You can also watch `./lib` files in case you want to restart the app when updating dependencies, that’s up to your preferred workflow.

And you can even keep an eye on other paths to perform other specific actions.

How would you adapt it to your own projects?
