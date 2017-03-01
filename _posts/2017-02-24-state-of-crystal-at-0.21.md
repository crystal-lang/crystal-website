---
title: State of Crystal at 0.21
summary: What did we do since new year?
thumbnail: ℹ️
author: spalladino
---

With the release of [version 0.21](https://groups.google.com/d/msg/crystal-lang/sGxeIxlLKX4/VFIM-iTECwAJ), we wanted to share with you the state of Crystal development so far this year, aiming towards a [1.0 version](https://crystal-lang.org/2016/12/29/crystal-new-year-resolutions-for-2017-1-0.html) by the end of the year.

First and foremost, we have updated our [roadmap](https://github.com/crystal-lang/crystal/wiki/Roadmap) with the goals we have in mind, not just for Crystal during this year, but also tools we would like to see built using the language in the future, such as a full DSL for easily writing Ruby extensions, or a desktop UI library. We have also changed our [labelling scheme](https://github.com/crystal-lang/crystal/labels) for GitHub issues, and updated the [contributing guidelines](https://github.com/crystal-lang/crystal/blob/master/CONTRIBUTING.md) accordingly, to make it easier for anyone in the community to find out how to help with Crystal.

Regarding the key features we had identified for 1.0, we are making steady progress on [Windows support](https://github.com/crystal-lang/crystal/pull/3582), with work from community member [lbguilherme](https://github.com/lbguilherme) and core team member [bcardiff](https://github.com/bcardiff). Today Crystal is able to compile some programs in Windows, and the last milestone has been support for exceptions in that platform. We still have a long way to go on the standard library front, as every module was implemented with just UNIX support in mind, so contributions are most welcome from anyone interested in the Windows platform.

The next big thing is [parallelism](https://github.com/crystal-lang/crystal/tree/thread-support), with core team members [ggiraldez](https://github.com/ggiraldez) and [juanedi](https://github.com/juanedi) working heavily on it, based on the work started by [waj](https://github.com/waj). We are happy to have a working version of the compiler built with multi-thread support, with a similar model to Go: a fixed thread pool that executes tasks from fibers, including goodies such as work-stealing. Work on this is still experimental, and there are quite a few breaking changes to define, such as explicit Thread handling; but most of the compiler and standard library specs are currently green. Kemal’s author [sdogruyol](https://github.com/sdogruyol/) even managed to [run the web framework](https://twitter.com/sdogruyol/status/833369972919382019) in multiple threads already. However, there is still much work to do on testing and performance, to ensure the contention produced by distributing the workload on multiple threads does not offset the speed gain.

We have also started discussions on the type system to ensure the feasibility of incremental compilation. We have identified some potential bottlenecks on generics and on modules-as-interfaces that will have to be addressed, and we’ll do our best to identify the breaking changes required as soon as possible, as well as minimise their impact.

On the communications front, we are also now cross-posting from our official blog to the awesome platform [dev.to](https://dev.to/), where you might be reading this post now. The folks at [ThePracticalDev](https://twitter.com/thepracticaldev) were super friendly and set up a [crystal-lang account](https://dev.to/crystal-lang/) for us in no time on the site. Many of us in the Crystal core team have been following the site and twitter feed for quite some time, and are now really excited to see Crystal have a room in the platform.

Also, and not to spoil the surprise, but we have almost finished a brand new version of our website, with a much cleaner design. Expect to see it online quite soon.

Last but not least, we are happy to have given talks at [Google NYC](https://www.youtube.com/watch?v=8FvrBLWUwxc) and Recurse Center earlier this month, as well as organised another meetup. We are also organising the first Crystal Code Camp for April in San Francisco: [let us know](https://docs.google.com/a/manas.com.ar/forms/d/e/1FAIpQLSdN4a-ELm54lZFr_qcD97YLe-OTYnP7vAzMfpQdreCoG4o8_Q/viewform) if you are interested in joining, or [contact us](mailto:crystal@manas.tech) if you want to sponsor the event!

We’ll share news from the state of Crystal in a regular basis, so make sure to stay tuned to the blog and other [communication channels](https://crystal-lang.org/community/). Happy Crystalling!
