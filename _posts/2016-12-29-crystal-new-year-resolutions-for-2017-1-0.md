---
title: "Crystal new year resolutions for 2017: 1.0"
summary: ""
thumbnail: "🎉"
author: spalladino
---

Crystal has gone a long way since we [started it over five years ago](https://manas.tech/blog/2016/04/01/the-story-behind-crystal/). What was once an experiment to see if it was possible to have a compiled yet Ruby-like language, is now a trending language with over [7,000 github stargazers](https://github.com/crystal-lang/crystal/stargazers) and almost [1,400 shards](http://crystalshards.xyz/). Its popularity has risen considerably in the last few years, and we are incredibly proud to see something we have built resonating so much with the development community.

**Our primary goal for Crystal is to see it thrive:** we love to hear success stories of fellow devs, from many getting to know the language, to others using it at work to solve real-life problems. Having said that, we started looking on how to achieve this goal and looked for the major roadblocks for the language to be widespread used.

The major issue is clear: **stability**. While Crystal is a beautiful language to play with, investing on using it at work to implement a system that should be maintained for the long run seems risky for many developers. And with good reason: we are still labeling Crystal as alpha stage, even if it **has been production-ready for quite some time already**.

As such, and in line with our goal of seeing the language grow, we are setting a **new year resolution to have Crystal reach the 1.0 milestone in 2017**.

# What 1.0 means

Alpha, beta, and stable (i.e. 1.0) might mean different things for different people, even within the very Crystal team. The fundamental idea behind achieving a 1.0 milestone is to **reach a point where breaking changes to the core of the language are down to a minimum**. There can (and will, believe me) be more additions and features to the language afterwards, of course, or even modifications to tools or the standard library, but we want to assure that migrating to a subsequent version of the language should be an easy task.

# The road towards a 1.0 release

To reach 1.0 we need to work on those key features that could require breaking changes to the language; and we have identified the following:

- **Parallelism**: This is the next-big-thing we are working on currently. Though fibers work great for [concurrency](https://crystal-lang.org/reference/guides/concurrency.html), we want the language to be able to make use of all the computing power available. Considering that one of Crystal’s main goals is delivering the best possible performance, we want to achieve this not just for 1.0, but for beta actually (for whichever definition of beta you may like).
- **Windows support**: We are aware that there is a significant portion of the development community working on Windows who would like to get their hands on Crystal; also, Windows support would allow Crystal to be a good fit for developing cross-platform desktop apps. We plan to work close to the community to estimate and guide the efforts towards achieving this task, and ensure that no key elements of the language are tied to UNIX specifics.
- **Type system**: Crystal’s elegant type system and global type inference is one of its best features, but we are aware of several points that need to be reviewed, specially around generics and their constraints. We will be tidying up the type system, and even start looking into ways of formalising it, until we are satisfied that no surprises are lurking around the corner.
- **Incremental compilation**: Even if compilation times for the largest Crystal projects are currently not excessive (Crystal itself being the prime example at about 20s), if we want to improve the developing experience we need to be able to cut down these times. We want to prototype some incremental or even modular compilation features in the language, to identify any potential restrictions we might need to add to achieve this; note that we don’t consider this a must-do for 1.0, but the language changes that might arise from it are, hence the need to explore potential implementations.
- **Macros**: Crystal’s response to dynamic languages metaprogramming feature are [compile-time macros](https://crystal-lang.org/reference/syntax_and_semantics/macros.html), which provide a way to solve most of the same problems. Macros can manipulate an AST to output new code, call external programs, have access to the type system, or even hook into the compilation process. As such, part of the work before 1.0 will be to review them, and make sure they play along well with the rest of the language, as we don’t want to have any breaking changes to the macro language after 1.0.
- **Syntax**: Similar to the point above, once 1.0 is released, any changes to the language’s syntax will be frozen. Though Crystal has inherited most of Ruby’s syntax, some Crystal-specific items need a syntax of their own. Sincerely, we don’t anticipate any big changes here, but it would be irresponsible to freeze it without a proper review.

# How to get there

Considering we still plan on working on the standard library in parallel, as well as in fixing any bugs that come along the way, achieving all of the items above within a year is no easy feat.

First of all, since we at Manas are keen to see this happen, **we will be increasing our dedication towards Crystal itself**. The current team behind Crystal at Manas, [Ary (asterite)](https://manas.tech/staff/ary), [Juan (waj)](https://manas.tech/staff/waj), and [Brian (bcardiff)](https://manas.tech/staff/bcardiff), will be joined by [Gustavo (ggiraldez)](https://manas.tech/staff/ggiraldez), [María (mdavidmanas)](https://manas.tech/staff/mdavid), [Martín (mverzilli)](https://manas.tech/staff/mverzilli), [Matias (matiasgarciaisaia)](https://manas.tech/staff/mgarcia), and [me (spalladino)](https://manas.tech/staff/spalladino). We will be helping in community management, support, documentation, tooling, shards development and even core language development. Even if some of us were already contributing to the language in some free time, we are now officially backing the effort directly from within [Manas.Tech](https://manas.tech/).

And second, but not less important, we plan on **leveraging all the power of the open source community**. We are aware of more people who would like to start contributing to Crystal (not just through monetary donations) and whose expertise would be a great addition, though guiding these efforts need careful planning. We will be **improving our contribution guidelines and tidying-up the issue tracker** to ease these process, help keep the [community channels](https://crystal-lang.org/community/) organized, and keep the roadmap up-to-date.

After that, from the community perspective, we plan to work on **lowering the barrier for newcomers to the language**. We want to make sure it’s clear what Crystal is and what it is not, especially with so many people coming directly from a dynamic languages background. We will focus not just in documentation but in tutorials as well, and assist in defining use cases for Crystal that could in turn shape the language itself.

# Next steps

As excited as we are about all the things to come to Crystal during 2017, we don’t want to lose track of the **immediate next steps**. We will be working heavily on parallelism first, and on leveraging any existing efforts towards Windows support. From the community standpoint, we will be reviewing the contribution guidelines and rethink the GitHub issues labels, then re-tag issues as appropriate; we want to have issues ready for newcomers to contribute, as well as for more experienced members of the community to tackle.

Please do leave us your comments either here or through any of the [community channels](https://crystal-lang.org/community/). We wish you a happy new year, and as always, happy Crystalling :-)

<br/>

- - - - -

<br/>

If you want to help us achieve this goal, please consider supporting Crystal on [BountySource](https://salt.bountysource.com/teams/crystal-lang)!
