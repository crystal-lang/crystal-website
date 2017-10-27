---
title: "Diploid and Crystal"
author: peter-schols,ivo-balbaert
description: "At Diploid, we have been using Crystal for quite some time now. We would like to share our experience in this interview, answering questions relevant to companies wanting to use Crystal for production."
---
> _This guest post is an interview that Ivo Balbaert had with Peter Schols from [**Diploid**](http://www.diploid.com/) about their Crystal in Production story. This interview will also be part of the [**Programming Crystal** book](https://pragprog.com/book/crystal/crystal) that Ivo is writting - and we can't wait to read!_
>
> _We'd like to thank both of them for taking the time to share their experience, and to invite any other companies or individuals using Crystal in a production environment to share theirs too - [**reach out**](/community/) if you'd like to!_

At [Diploid](http://www.diploid.com/), we have been using Crystal for quite some time now.
We would like to share our experience in this interview, answering questions relevant to companies wanting to use Crystal for production.

# About Us
Diploid is a company based in Leuven, Belgium. We provides services and software to hospitals and labs for diagnosing
rare diseases using clinical genome analysis.

# What are the production projects that you use Crystal for?
We are using Crystal for parts of Moon, the first software package to autonomously diagnose rare disease using artificial intelligence. Moon is being used by hospitals worldwide to diagnose patients with severe genetic conditions. The software requires the patient’s symptoms, as well as his/her genome data. It will then come up with the most likely mutation to explain the patient’s condition.

Before Moon, geneticists had to manually filter and rank mutations using special software in order to reach a diagnosis. This process can take several hours up to several days. Moon does the filtering and ranking automatically and proposes a diagnosis within 3 minutes.

Moon has been written mostly in Ruby. We’ve chosen Ruby for several reasons: rapid development, expressive syntax, lots of available libraries and a great ecosystem. All of this results in developer happiness and faster development cycles. But while Ruby is fast enough for most parts of Moon, it can be slow for the most performance critical areas of our codebase. That’s why we evaluated Crystal, among others, and eventually decided to develop in Crystal.

<img src="{{ 'blog/diploid-moon.png' | asset_path }}" class="center"/>

# Why did you decide to use Crystal for these applications?
When looking for a language that we could use to replace performance critical code in our Ruby codebase, we evaluated many options: Swift, Elixir, Go and Crystal. We specifically evaluated performance, syntax and ease-of-use. Performance was assessed using a small benchmark script that includes the performance critical
operations that are typical for genome analysis (mostly string operations). Go topped the performance list, followed by Crystal. Surprisingly, Ruby outperformed Swift. Go clearly won the performance criterium. Performance is not everything, however: infrastructure is very cheap compared to developer time. While Go is an interesting
language with a great concurrency model, it lacks in several other areas. Features that we take for granted in Ruby or other languages, are not available in Go. Examples include operator overloading or keyword extensibility, as well as true OOP. Moving from Ruby to Go sometimes feels like ignoring 20 years of progress made in language design.

Crystal, as the second best performer, combines this still excellent performance with a very Ruby-like syntax. Given that the rest of our code base has been written in Ruby, it’s a great match. Moreover, Crystal has a Go-like concurrency model, so it basically takes the best from the Ruby world (expressive syntax, full OOP) and
combines it with the best of Go (concurrency model, performance).

# What kinds of problems does Crystal solve best?
Any problem that is currently being solved by Ruby, Python, Go or Rust could potentially be solved in Crystal.
Given its similarity to Ruby, web frameworks will be an important part of the Crystal ecosystem. However, Crystal has a lot of potential in other fields too. Python is popular in data science, but it’s far from the fastest language. With Crystal, data scientists could have the ease-of-use of Python/Ruby combined with the performance
of C. These advantages could make Crystal very suitable for domains like bioinformatics, where performance is really important.

As many people in the bioinformatics field don’t have a formal CS/engineering background, having a language that is
easy to learn is important as well. Crystal does very well on both fronts.
In addition, due to its expressive nature and low barrier to entry - traits it inherited from Ruby - Crystal is a great tool for general scripting and systems software.

# How was your experience of developing with Crystal?
When coming from Ruby, working in Crystal feels like coming home. Syntactically, Crystal is highly similar: the only major difference is the static typing. While this takes a bit to get used to, the transition was really smooth and easy. Many lines of code can literally be copied from a Ruby project and pasted into a Crystal project and they will just work. Some lines do need additional type annotations, however.

Apart from that, the only major difference is that the rubygems (Ruby libraries) ecosystem is very expansive. Crystal has its own version of gems, called shards. While the number of shards has grown exponentially in the past few months, it’s still way behind the rubygems ecosystem, or the Go ecosystem for that matter.

# Are there any aspects of Crystal that specifically benefit customer satisfaction?
The Crystal code we use in production was not ported from Ruby, it was written from scratch in Crystal. However, in order to test the difference in performance - and also out of pure curiosity - we ported the code from Crystal to Ruby. For this particular project, we noticed that the Crystal version was 4.4x - 6.1x faster.
This made a big difference in user experience. It means that for smaller data sets, Moon can present results in near real time (about 540 ms), which feels instant to the user. The corresponding Ruby program takes 2.5 seconds for the same task. When analysing larger data sets, the difference was even bigger: on average 27 seconds for Crystal compared to 2 minutes and 50 seconds for almost exactly the same Ruby code, a more than 6x speedup! When analysing hundreds of samples, these time differences become even more important.

# What advantages or disadvantages have you experienced from deploying a Crystal application in production?
As mentioned, the speed increase is really significant. In addition, the ability to create a binary is convenient, as it allows for easy deployment. Compiling a binary also allows us to easily share software with our internal users
and testers. With Ruby, we need to setup rvm or rbenv, install the latest Ruby version, install rubygems and install all required gems. With Crystal, it’s as easy as copying one file.

# What do you like the most about Crystal, compared to other languages?
Performance, the ability to create real binaries and the Ruby-like syntax are the most important Crystal selling points for me. Another advantage is that Crystal makes it very easy to create bindings to a C
library - no need to write C code.
Last but not least, Crystal has an amazing community of friendly and skilled developers. It started with Ary, Juan and Brian at Manas, creating the language and helping the Crystal newbies. In the meantime, it seems like the entire community has copied their attitude of providing help and pointers to everyone who’s interested in this very promising language.

# Useful links
[Diploid](http://www.diploid.com/)

[Moon software](http://www.diploid.com/moon)
