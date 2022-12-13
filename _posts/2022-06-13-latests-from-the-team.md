---
title: Latests news from the Crystal Team
summary: A sneak peak of what kept the team busy in the past months
thumbnail: +
author: beta-ziliani
---

Here we tell the community what's been on the team's plate for the last couple of months, focusing on those aspects that aren't visible in Crystal's main repo.

## Documentation improvements

We directed efforts to [improve the documentation](https://github.com/crystal-lang/crystal-book/pulls?page=1&q=is%3Apr++merged%3A%3E%3D2022-01-01), since that's where users are guided to when first learning the language. This is part of an on-going task to improve newcomers experience with the language.

> **NOTE:** Shameless plug #1
> Our @ftarulla is writting about his experience with Crystal in his [dev.to channel](https://dev.to/franciscello/) that you can follow.

## A long and exciting hiring process

As you probably know already, Crystal's been actively working to [grow its team](https://forum.crystal-lang.org/t/call-for-crystal-language-devs/4366). We can't share the news just yet, but it was interesting to see many familiar faces in the process! Hiring processes can certainly be intensive! And we're not even finished yet… 🥵 But it will definitively be worth the effort. More on that on a separate post 😀

> **NOTE:** Shameless plug #2
> [Manas.Tech](https://manas.tech) is still hiring in a number of other [positions](https://manas.tech/join)!

## Garbage Collection

A significant part of the time of an application goes into allocating/deallocating objects, a task that is handled by the garbage collector. Currently, Crystal uses [the Bohem-Demers-Weiser collector](https://github.com/ivmai/bdwgc), a great collector that works fine for a vast majority of applications. However, we are seeing two areas with potential for improvements in this regard:

1. Can a modern collector perform better for some applications?
2. Can we _own_ the collector and improve its performance exploiting the internal knowledge of Crystal's memory mapping?

We started researching using an existing [garbage collector](https://github.com/ysbaddaden/gc) based on [IMMIX](https://www.cs.utexas.edu/users/speedway/DaCapo/papers/immix-pldi-2008.pdf), created for Crystal by former core-team member Julien Portalier. Currently, we're at the point in which it's usable in Linux, to the point that we can compile Crystal with it.

As a side benefit, adding a second collector gives us the experience to eventually incorporate the still green [Memory Management Toolkit](https://www.mmtk.io/), which aims at having different collectors to pick from using a unified interface.

That's all for now, keep it safe... and _fast_!
