---
title: Genome analysis powered by Crystal
author: mpettinati
description: Rapid rare disease diagnosis using genome analysis
company: Diploid
image: /assets/blog/2019-07-17-diploid.webp
categories: success
---

[Diploid](http://www.diploid.com/) is a company based in Leuven, Belgium, who provides services and software to hospitals and labs for diagnosing rare diseases using clinical genome analysis.

What makes Diploid so interesting is that they developed [Moon](http://www.diploid.com/moon), the first software package to autonomously diagnose rare diseases, using artificial intelligence. Moon is currently being used by hospitals worldwide to diagnose patients with severe genetic conditions.

Why is that relevant and interesting? Because, before Moon, geneticists had to do the filtering and ranking of mutations manually, using special software, in order to reach a diagnosis. This software simply requires to input the patient’s symptoms, as well as his/her genome data, to come up with the most likely mutation that explains the patient’s condition. This process usually took from several hours up to several days. Moon does the filtering and ranking automatically and proposes a diagnosis ***within 3 minutes***.

So, you might be wondering how can it do this so fast. The answer is **Crystal**: Moon was written mostly in Ruby, but while this language is fast enough for most parts of Moon, it can get slow for the most performance-critical areas of the codebase. That’s why Diploid decided to develop the software using [Crystal](https://crystal-lang.org), because this language combines excellent performance with a very Ruby-like syntax, which is very expressive and allows developers to code faster.

For this particular project, **Crystal turned out to be between 4 and 6 times faster than Ruby**, which makes a big difference in terms of user experience. It means that for small data sets, Moon can present results in near real time (about 540 ms), which feels instantaneous to the user.

Peter Schols, Diploid’s CEO, was very satisfied with these results.

{% include components/testimonial-profile.html handle="peter-schols" role="CEO, Diploid" %}

> Crystal [...] combines this still excellent performance with a very Ruby-like syntax. Given that the rest of our code base has been written in Ruby, it’s a great match. Moreover, Crystal has a Go-like concurrency model, so it basically takes the best from the Ruby world (expressive syntax, full OOP) and combines it with the best of Go (concurrency model, performance).

**People are talking about this story:**

[https://crystal-lang.org/2017/10/27/diploid-and-crystal.html](https://crystal-lang.org/2017/10/27/diploid-and-crystal.html)

[http://www.diploid.com/moon](http://www.diploid.com/moon)

[https://researchstash.com/2017/06/14/a-european-startup-is-revolutionizing-the-genome-diagnostics-through-artificial-intelligence/](https://researchstash.com/2017/06/14/a-european-startup-is-revolutionizing-the-genome-diagnostics-through-artificial-intelligence/)

[https://www.bio-itworld.com/2018/05/16/2018-best-of-show-winners.aspx](https://www.bio-itworld.com/2018/05/16/2018-best-of-show-winners.aspx)

[https://www.genomeweb.com/informatics/moon-software-launch-diploid-aims-accelerate-diagnosis-rare-genetic-diseases](https://www.genomeweb.com/informatics/moon-software-launch-diploid-aims-accelerate-diagnosis-rare-genetic-diseases)

[https://datanews.knack.be/ict/nieuws/leuvense-software-helpt-met-wereldrecord-genoomanalyse/article-normal-965499.html](https://datanews.knack.be/ict/nieuws/leuvense-software-helpt-met-wereldrecord-genoomanalyse/article-normal-965499.html)
