---
title: "Automating smart buildings with Crystal"
subtitle: "How PlaceOS creates and manages cohesive environments"
author: stakach,pettimart
summary: "<b>Stephen Von Takach Dukai</b>, <b>Engineering Lead</b> at PlaceOS, talks about their experience working with Crystal."
comment_href: https://disqus.com/home/discussion/crystal-lang/automating_smart_buildings_with_crystal_how_placeos_creates_and_manages_cohesive_environments/
image: /assets/blog/2023-01-24-placeos.png
company: PlaceOS
categories:
- success_stories
---
[PlaceOS](https://place.technology/) provides a platform that allows a seamless integration between the physical and the digital. And then they automate it all, to create state-of-the-art cohesive ecosystems in the traditionally conservative space of facility management.

We sat down with **Stephen Von Takach Dukai**, **Engineering Lead** at Place, to talk about their experience working with Crystal.

**What projects are you currently using Crystal for? Are they all in production? Are they client-facing or internal tools?**

We're effectively a Crystal-lang house for all things backend. Most of what we do is running in production, both client-facing and internal tools. All services we built are Crystal except for one remaining Ruby service.

We're also a big proponent of open source, so you can find our work at:

* [spider-gazelle](https://github.com/spider-gazelle) - shards we consider reusable with community benefit

* [PlaceOS](https://github.com/PlaceOS) - our core platform, primarily useful for partner organizations

* [place-labs](https://github.com/place-labs) - mostly supporting shards for PlaceOS

Also, some of our SaSS / cloud platform software, which includes platform management and billing software, is closed source —but that's all Crystal-lang too.

**How did you learn about the language, and what went into the process of choosing it for your stack? What alternatives did you evaluate, and what other languages are you using?**

I think we first noticed Crystal when Mike Perham, creator of Sidekiq, released a Crystal-lang client.

We had been using Ruby for our platform and were hitting scalability limits. Originally we selected Ruby as it's a very expressive language and we had some experience with Rails. However, we ended up having to build our own IO reactor based on Libuv to get the performance we needed.
Ruby being released in 1996 meant its design pre-dates things like epoll, for high performance IO, which debuted in 2002.

Really the only other language that was close to meeting our needs was Go-lang, but coming from Ruby we felt Crystal would be an easier transition for our developers. In fact I don't think we could have succeeded with Go-lang. Crystal features such as macros and generics have been critical to success from the start.

The other language we use is TypeScript as our frontends are built on the Angular framework.

**What were some advantages of developing in Crystal, and what were some problems?**

Coming from Ruby I personally have found Crystal to be a breath of fresh air. I originally moved from C++ and C# to Ruby, as the language I worked on day to day, and had a similar feeling back then.

Productivity with Ruby on Rails felt so much higher, I could move fast and be more creative. However, more recently, especially when the solutions were getting bigger and more complex, Ruby felt like an achilles heel: random bugs that are hard to reproduce with unexpected objects in unexpected code paths were really eating up developer time.

Crystal solved most of what felt wrong with Ruby. Types and  the smart features of the compiler being the obvious first thing, we were definitely writing better Ruby code after dipping our toes into Crystal. But we also found the Crystal tooling to be great, the formatter, linters like Ameba, testing tools, leveraging LLVM, minimal Docker containers and the community, all helped sway us.

The biggest problem was probably a lack of mature shards at the time, but this just meant we could shape the missing pieces to meet our needs and porting Ruby Gems is typically not much of an issue. Frankly, it's amazing how many bugs we found in every gem we ported just thanks to the Crystal compiler.

**What would you say is a benefit of using the language for your own operation, and what for your end customer?**

The benefit to us is the developer productivity of Ruby, with increased confidence in what we're releasing and less focus required on performance. This translates to higher quality applications for customers and cleaner codebases for us.

One example of this is the web framework we built, [Spider-Gazelle](https://spider-gazelle.net/). Originally built as a Rails clone, it now leverages Crystal magic to generate [OpenAPI](https://www.openapis.org/) docs, making it more useful and faster than Rails.

API documentation was time consuming for developers so this has increased our developer productivity, docs are more accurate (in many cases, now exist) and our compute expenditure is lower when compared to Ruby.

**What kind of problems would you say Crystal solves best?**

One awesome use case is portable Linux executables. We developed a service that can be deployed on the edge (typically network switches in a client's building) and this edge processor downloads statically linked drivers, which are Crystal executables built using musl libc.

For us Crystal is a perfect Web services platform and for doing most things you might otherwise use Ruby, Python or Go-lang for. We're using it to develop microservices of all shapes and sizes with both x86_64 and ARM64 support for Docker and k8s deployments.

As more developers start using the language, and shards are built out, I can imagine Crystal surpassing both Ruby and Python as the go-to language. It has the benefits of Go-lang and Ruby in the one package, which is a pretty strong multiplier.
