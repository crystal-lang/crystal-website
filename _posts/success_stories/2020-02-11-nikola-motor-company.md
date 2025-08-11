---
title: Crystal powered dashboards on the trucks of the future
author: mpettinati
summary: Nikola’s electric trucks use Crystal for their infotainment and telematics system.
company: Nikola Motor Company
image: /assets/blog/2020-02-11-nikola.webp
categories: success
---

[Nikola Motor Company](https://nikolamotor.com/) is on a mission to transform and disrupt the transportation industry on a global scale, and [Crystal](https://crystal-lang.org/) is powering their software. They design and manufacture both Battery-electric (BEV) and Hydrogen fuel-cell (FCEV) vehicles, vehicle components, energy storage systems, and electric vehicle drivetrains. These are the trucks of the future.

Nikola has developed several different vehicles, all of them super innovative and highly performant: three models of class-8 electric semi trucks –~~[Nikola One](https://nikolamotor.com/one)~~, [Nikola Two](https://nikolamotor.com/two) and [Nikola TRE](https://nikolamotor.com/tre)–, two off-road fully-electric vehicles –~~[Nikola NZT](https://nikolamotor.com/nzt)~~ and ~~[Reckless](https://nikolamotor.com/reckless)~~, a military grade OHV–, and the ~~[Nikola WAV](https://nikolamotor.com/wav)~~, an electric watercraft. From production to consumption of energy, they work towards complete zero-emissions, and they’re bringing them to production over the next few years starting with the testing and validation of the Nikola TRE in 2020.

An important focus of the company is their customers experience: speed, comfort and safety are intentionally integrated in everything they do. Along that line, their vehicles are equipped with a state-of-the-art digital cockpit: most of their vehicles’ functions and driver controls are operated via a central 17” touchscreen Infotainment & 12.8” Instrument cluster, developed in Crystal.

![The front panel of a Nikola truck](/assets/blog/2020-02-11-nikola-truck-front-panel.webp)

When we learned about this, we couldn’t resist reaching out to Nikola Motor Company’s Chief Information Officer & Software Architect, [Isaac Sloan](https://www.linkedin.com/in/isaac-sloan-29b30526), to learn more.

**How did your story with Crystal begin?**

In a previous company I was working for, I spent about four years working mostly with Java, and in 2005, when I found out about Ruby, I "secretly" started migrating a bunch of code to Ruby. By the time the company found out, they tried to make me rewrite it, but when they saw how much it allowed me to accomplish they let me keep working in Ruby.

I learned about Crystal around March 2015 at Mountain West Ruby Conf, and started writing all my hobby projects in it. A few months later, we had some challenges with an application that was using too much memory, so I tried rewriting a few bottleneck points in Crystal and left the rest in Ruby/Rails, proxied it with NginX, and that proved to resolve the issue. From that point on, it was a natural transition.

**What are you currently using Crystal for?**

The infotainment, instrument cluster and telematics system (communications between the vehicle and the Cloud) is all written in Crystal with Amber Framework, and it’s built into all our vehicles. We have three different Crystal apps, mostly because it makes sense to run them separately so we can give them different privileges, but they’re all integrated: one that runs as root and handles privileges, another one behaves as a user interface, and another one communicates with the cloud. Crystal is the glue that holds everything together: the applications that connect every component in our platform are written in Crystal, we’re targeting x86 architecture, but we have been able to compile it on Raspberry Pi.

**What made you choose Crystal over other options for this project? Do you find the software you developed in Crystal performs better than the software you wrote on other languages?**

Well, we talked about several different alternatives. Rust wasn’t as conducive to work with, and somewhat overkill for our needs. Electron uses node.js for the BackEnd and Chromium for the FrontEnd, but for our use it consumed too much memory. We’re essentially following the Electron paradigm, but we use Crystal instead of node.js to generate all the APIs and HTML.

<u>It's a lot faster, twice as fast as Go, for example</u>. We tried using Go at first, because it's 1.0 and it’s quite popular, but in our experience Crystal outperformed Go and is more enjoyable to write. Both our investors and stakeholders love the infotainment system and how fast it runs.

For what we are trying to do, either C or C++ are pretty much the standard. We are also trying to work with web utilities and web languages like html, javascript and chromium. We talked to a lot of people on the WebOS project, because they proved that it worked on very small processors and mobile devices as an interface.

It’s also reasonably easy to write C Bindings in Crystal. With Python or Ruby if there isn’t already a binding or wrapper for a C Library it takes a lot more time. I have been using Crystal for a lot of years now, on servers and clients, and it never crashed. It may not be stable in the sense of “no breaking changes”, but <u>it’s very stable in the sense that once it compiles it won’t crash. Either way, it’s more stable than Java</u>.

**When did you start using Crystal at Nikola? Did you use it on any previous projects?**

It's been on our codebase for over two years now. We went through multiple iterations of this application, and we’re finishing our production goals right now. The automotive industry takes a lot of time to get everything validated, and in the process, stakeholders sometimes require changes, so it’s always evolving.

**Do you have any plans to expand your usage of Crystal on your upcoming projects?**

Right now, we’re validating everything in terms of safety and security. Going forward in the next few months, we’ll be working on interfacing with mobile phones for remote control, all of which will be integrated with the Crystal app.

{% include components/testimonial-profile.html handle="elorest" role="CIO & Software Architect, Nikola Motor Company" %}

> I love working with Crystal. It has a lot of the happiness value that Ruby had at the beginning, and the community is doing really amazing things.
