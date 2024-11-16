---
title: "LavinMQ: Understanding code to get the best performance"
summary: "Crystal was chosen for maintaining control over the entire codebase."
author: beta-ziliani
image: /assets/blog/2024-05-22-lavinmq-terminal.png
company: 84codes
categories: success
tags: [84codes]
---

Building LavinMQ in Crystal was an active choice, as maintaining control over the codebase was a high priority. A decade of learning has prioritized fast updates and easy bug fixes. At the same time, choosing Crystal provided the opportunity to enhance application performance.

[LavinMQ](https://lavinmq.com/) was built by experienced developers from 84codes, founders of one of the largest cloud messaging platforms, [CloudAMQP](https://www.cloudamqp.com/). By prioritizing the insurance of stable communication and reliable message delivery in and between services, LavinMQ was built to process data quickly and efficiently while allowing decoupled system components to operate independently and scale as needed.

LavinMQ can handle numerous connections between the publisher, the queue, and the consumer, which is often a requirement in e.g., IoT architectures. It’s an open-source message broker, pre-optimized to be extremely fast compared to other brokers, and can easily handle 1 million messages per second.

LavinMQ includes all the features people want the most and leaves just a small memory footprint, supporting:

* Streaming
* Flexible Routing
* AMQP 0.9.1 Protocol
* Acknowledgments and Confirms
* Stream Queue
* Unlimited Queue Length (dependent on disk space)
* Replication

We highlighted the characteristics that stand out from a technical point of view. How does it manage to handle more than a million messages per second, and have a low memory footprint? Half of it is due to, and we quote:

> Messages are written to the disk really fast and the caching is managed by the OS itself. This leads to a performance boost while keeping RAM footprint low.

But the other half, as mentioned in [their blog](https://lavinmq.com/blog/crystal-clear-message-brokering), is due to it being developed in Crystal. And this comes in several interesting ways.

1. Crystal is efficiently compiled thanks to its LLVM backend. This enables aggressive optimizations, like inlining methods and removing indirections.

2. Crystal helps developers allocate their data either on the heap or on the stack. Heap allocations are expensive, so allocating data on the stack in the hot-path of the program brings an important boost in performance. Crystal makes it easy to choose where data should be stored.

3. Crystal's stdlib and compiler are written in Crystal itself. One of Crystal's golden characteristics is its readability, making it possible to read the code that is going to be run by the program without having to resort to another, typically lower-level  language.

The latter is the main point of this post. In fact, the documentation of the standard library points to the code, making the performance implications of calling a certain method explicit. For example, look at the [documentation for `Digest.file`](https://crystal-lang.org/api/1.12.1/Digest.html#file%28file_name%3APath%7CString%29%3Aself-instance-method). Clicking on [*View source*](https://github.com/crystal-lang/crystal/blob/4cea10199/src/digest/digest.cr#L214) we land in the method’s code.

The importance of being able to read, understand, and even contribute to the language and its stdlib is exemplified in [one](https://github.com/crystal-lang/crystal/pull/13780) of the [several PRs](https://github.com/crystal-lang/crystal/pulls?q=is%3Apr+author%3Acarlhoerberg+) that 84codes contributed to Crystal. Details are not important, but if you’re curious, they noted that in the aforementioned `Digest` class’s method there was a duplication of buffering. The following extract shows the main part of the contribution; the diff with the added line and comment explaining why it makes sense to remove the buffering in the `io` object.

```diff
diff --git a/src/digest/digest.cr b/src/digest/digest.cr
index e6a401e90545..bc38599da7f8 100644
--- a/src/digest/digest.cr
+++ b/src/digest/digest.cr
@@ -213,6 +213,7 @@ abstract class Digest
   # Reads the file's content and updates the digest with it.
   def file(file_name : Path | String) : self
     File.open(file_name) do |io|
+      # `#update` works with big buffers so there's no need for additional read buffering in the file
+      io.read_buffering = false
       self << io
     end
   end
```

One little line, yet it can have a noticeable impact on the application. Having the same language for the application and the libraries the code depends upon is a great advantage in understanding the behavior of the code and its performance implications.

Before closing, we’d like to note that 84codes is not only responsible for numerous improvements to the standard library: 84codes is also the main sponsor supporting the development of Crystal. In order to push the limits of the language even further, at the time of writing they are supporting a large effort to improve [the parallel execution](https://crystal-lang.org/2024/02/09/84codes-manas-mt/) of Crystal programs. Perhaps the next version of LavinMQ will push the limits even further with the help of the Crystal Team!

{% include components/testimonial-profile.html handle="carlhoerberg" role="CEO, 84codes" %}

> Crystal uniquely balances readability and performance. Moreover, we are able to boost our application performance by being able to understand the underlying code that runs our application.
