---
title: "84codes and Manas partner to iron multi-threading support"
author: beta-ziliani
summary: "Together we can make the most of multi-threaded applications"
image: /assets/blog/partners/manas+84codes.png
partner_images:
- src: /assets/manas-orange.svg
  name: Manas.Tech
  href: https://manas.tech/
- src: /assets/sponsors/84codes.svg
  name: 84codes
  href: https://www.84codes.com/
categories: project
tags: [Manas.Tech, 84codes, multi-threading, partnership, sponsors]
---

In 2019, we announced that Crystal had [multi-threading support](https://crystal-lang.org/2019/09/06/parallelism-in-crystal/). Since then, users wanting to squeeze a bit of those cores have the possibility to compile the app with the `-Dpreview_mt` flag and have access to parallel processing. However, five years later, the situation has not advanced much, with a working implementation that remains a preview feature.

[84codes](https://www.84codes.com/)’s flag-ship product [LavinMQ](https://lavinmq.com/), strives to be the most efficient messaging queue server. To optimize server capabilities, 84codes has decided to financially support the significant task of introducing full multi-threading support in the compiler and stdlib. The [RFC](https://github.com/crystal-lang/rfcs/pull/2/) is currently under scrutiny, and development has already started, as seen in several recent PRs on the topic of [concurrency](https://github.com/crystal-lang/crystal/pulls?q=is%3Apr+sort%3Aupdated-desc+label%3Atopic%3Amultithreading%2Ctopic%3Astdlib%3Aconcurrency).

We know this task is not easy and will take time. However, the expected outcome is promising: not only are we working to have better performance, we are also aiming to make the API flexible enough to accommodate the needs of the different applications.

If you are facing difficulties with your Crystal application, you are welcome to reach out to [crystal@manas.tech](mailto:crystal@manas.tech). Manas can help you crack that hard nut, and the solution might end up enriching the Crystal ecosystem.
