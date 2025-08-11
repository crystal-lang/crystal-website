---
title: "Bright and Manas partner together to create Crystal development tools"
author: beta-ziliani
summary: "The story behind four development tools that were released recently"
comment_href: https://disqus.com/home/discussion/crystal-lang/bright_and_manas_partner_together_to_create_crystal_development_tools_37/
categories: project
tags: [Manas.Tech, Bright, partnership, sponors, tooling, feature]
image: /assets/blog/partners/manas+bright.png
partner_images:
- src: /assets/manas-orange.svg
  name: Manas.Tech
  href: https://manas.tech/
- src: /assets/sponsors/bright.png
  name: Bright
  href: https://brightsec.com/
---

In the recent [Crystal 1.10 release](/2023/10/09/1.10.0-released/) two new compiler tools were introduced: `crystal tool dependencies` and `crystal tool unreachable`. In parallel, the Crystal team also released [perf-tools](https://github.com/crystal-lang/perf-tools), a shard with tools for tracking memory usage and fibers. In this post, we delve into the story of how these tools came to be.

The development of these tools was sponsored by [Bright](https://brightsec.com/), makers of an intelligent exploiter for securing websites. The exploiter works by searching for endpoints and attacking them with a large set of potential security threats. As an established product, it has grown organically over the years, requiring special tools to improve it. Therefore, Bright asked Manas to help out in two major subjects: refactoring of the application and hunting memory leaks.

## Refactoring

The application has two distinctive features: discovering endpoints, and attacking them. From an architectural point of view, it made sense to split them into two different applications. This was a major refactor that required to identify which parts of the source tree belong to which application.
To simplify this process, we built `crystal tool dependencies`, which shows a tree of `require` dependencies. It becomes easier to split the application following the require graph.

Additionally, `crystal tool dependencies` helps understanding conflicts arising from the `require` order. For instance, if two files `a.cr` and `b.cr` define the same method for a class, Crystal uses the definition coming from the last file being required. With this tool we can then observe the order in which `a.cr` and `b.cr` are required and therefore understand why Crystal is calling one of the definitions and not the other.

To complete the separation, we needed to identify dead code in each require trees. For this purpose we built `crystal tool unreachable` to show `defs` that are defined but never called.

## Memory leak hunting

In certain cases, the application’s memory consumption could grow indefinitely until exhausting the global memory. To inspect memory usage and catch leaked fibers, we created two tools, available in the [perf-tools](https://github.com/crystal-lang/perf-tools) shard. The first tool is `mem_prof`, which once imported tracks memory allocations, allowing for the listing of memory allocations per location or per type. For instance, it is possible to track if there is an instance of a class that is holding a large amount of data. If the instance should be _garbage collected_ after certain point to release memory, and it is not, then that might lead to a leak.

The second tool is `fiber_trace`, which lists the running fibers together with their allocation point and the yield point —the place in which the fiber returned execution to the scheduler. An example of use is to track if a fiber is still alive, and if so, what was the last operation that it did.

Together, these two tools helped us and the Bright team fix several leaks.

## Conclusions

Working on a large production application was an enriching experience, and building the necessary tools helped us improve the compiler and its ecosystem. We are very thankful to Bright for their support.

If you are facing difficulties with your Crystal application, you are welcome to reach out to [crystal@manas.tech](mailto:crystal@manas.tech).
Manas can help you crack that hard nut, and the solution might end up enriching the Crystal ecosystem further with new or improved tooling.
