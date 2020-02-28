---
title: Towards Crystal 1.0
summary: The upcoming efforts to release Crystal 1.0
thumbnail: +
author: bcardiff
---

Currently the main goal of the Crystal core team is to reach 1.0 in the near future. Since achieving that goal involves a number of non-obvious tradeoffs, we want to use this post to shed some light on those inherent tensions and how they drive our work and priorities for the next few releases.

There are three main aspects of the Crystal ecosystem that in a way compete for resources and design decisions (when we say "Crystal ecosystem", we mean: the compiler, the std-lib, official-ish and community shards, apps that depend on Crystal, and the community itself):

The language is already widely used, so we want to minimize the number of breaking changes, and when we can’t avoid them, at least minimize their impact on existing codebases.
We want 1.0 to be a stable version of the language.
We want the language to keep evolving (said another way, we don’t want the fact that we reached 1.0 to mean that we’re left with an ossified language).

The challenge at hand is to get as quickly as possible to a 1.0 version of Crystal that is at the same time as faithful as possible to the current state of the language, stable enough for individuals and organizations to feel comfortable adopting it for even their highest impact projects, and a solid foundation for future major versions.

Considering this context, the most important question to answer almost continuously is: what should happen before 1.0 and what can wait? Let’s delve into that!

## What **can** wait? - after 1.0

Since we created Crystal, the language kept evolving through a very free process of exploration of new ideas, sometimes experimental ones, that we hoped would bring joy and productivity to the programmer at the end of the day. Sometimes these ideas end up requiring changes in the language. We want to continue receiving and exploring these new ideas, because these organic processes are what made Crystal what it is.

However, paying excessive attention to these kinds of novel ideas takes away precious resources and focus from the main goal of releasing 1.0. While approaching that, there will be less focus on new and enhanced features that require changes to the language.

There are also important features that are strongly wanted, but they do not require changes in the language itself. These will likely keep receiving lots of attention from the community and we will do our best to review and give feedback to help them move forward. But we will mainly be focused on the features that are holding back 1.0.

Let us go over some of those features, which might well make it into eventual 1.x versions of the language:

**Windows**: We aim for most of the shards and apps built on Crystal to be portable. The std-lib should hide platform specific aspects as well as possible. With that in mind adding more platforms to the supported list should not impact neither the language nor the public API. Again, recently we integrated a CI for Windows to ensure we continue moving steadily forward.

**Debugger**: Improving the debugging capabilities requires changes to the compiler and tool ecosystem but not to the language. There is ongoing effort from the community and further collaboration is expected and welcome. The current efforts are looking amazing. These may or may not land in 1.0, it depends a lot on timing of testing and feedback.

**Multi-threading**: There are pending stories to make multi-thread mode a non preview feature. To mention a few: which the desired guarantees for some parts of the std-lib are, or how the scheduler and runtime could be improved. We already polished `GC`, `Channel`, `select` and `IO` to behave correctly with multi-threading on. Future potential enhancements may allow you to use multiple threads more freely, but the core aspects of the language and runtime are set and done.

**X or Y compiler bug**: We will keep fixing them, before and after 1.0. Their existence didn’t prevent the existing community from building awesome stuff.

## What **can’t** wait? - before 1.0

So, what is missing to reach 1.0?

**tooling**: There are a couple of stories regarding tooling that are missing and need improvements. Shards needs to be more solid for 1.0 (you might have noticed some work in the last couple of weeks on that).

**multi-thread stability & documentation**: With 0.33.0 we added some new features for multi-thread and improved IO handling. We want and need thread-safe IO, Channel and runtime.

**std-lib polishing**: Although the std-lib will keep evolving we know there are a couple of modules that do need at least a couple of iterations. We want to improve the current API before 1.0 so we allow more solid solutions to be built upon these features. Some examples of these modules include logging, Errno and general exceptions type hierarchy, as well as removing clutter from the top-level namespace.

These areas are the ones Manas & the rest of the core-team will invest most of their effort until 1.0 is reached.

## Summary

With this post, we want to provide some clarity on what to expect and what not to expect from the Crystal core team for the next few months.

Of course, other areas that are not mentioned can still receive contributions. But we want to be transparent on the need to aim for fewer, smaller and self-contained changes in the API to include them in 1.0. Said another way, we’ll be much more conservative as regards our merge policy until we get to 1.0.

We already have many plans for after 1.0 that we’ll be excited to start sharing and investing efforts on after celebrating Crystal 1.0. Let’s get there first!

