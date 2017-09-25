---
title: "NeuraLegion and Crystal"
author: neuralegion
---

> _This is a guest post from the team at [NeuraLegion](http://neuralegion.com), telling their Crystal in Production story. We'd like to thank them for taking the time to share their experience, and to invite any other companies or individuals using Crystal in a production environment to share theirs too - [**reach out**](/community/) if you'd like to!_

At [NeuraLegion](http://neuralegion.com), we have been using Crystal for quite some time now.
We would like to share our experience in this brief article, starting from how we discovered Crystal, fell in love with it, and why we decided to make Crystal our language of choice.

# About Us
Before we begin our story about Crystal, let us introduce ourselves. We are a new startup company with a passion to make the world a better place through machine learning and AI. We're currently focusing on the cyber security world, an increasingly crucial part of our daily lives.

NexPloit, our first product (which will be released soon), will redefine software Penetration Testing through the power of AI.

# Why Crystal?
Grandiose statements aside, when we started working on our first product, we were already long time fans of Ruby. We love Ruby because it is object oriented by default, making it easy to use, it is versatile and has a good pool of libraries developed by the community. In addition, we find Ruby beautiful and well matured as a programming language.

However, when we rolled up our sleeves and began to build NexPloit, there were some innate characteristics of Ruby which did not fulfill our specific needs. To name a few examples:

1. Ruby does not provide explicit types. This has several implications, including the ability to infer data types, performance and sizing penalties and unnecessary manipulations the data has to go though. For our purposes, efficiency was a very important issue.
2. To solve the previous problem, C bindings are often used. However, they can be very tricky to implement. As we mentioned already, Ruby does not have explicit types. C on the other hand is a strongly typed language, but consciously knowing at any given time which type exactly to pass around can be a little daunting, and might take a few tries to make it work.
3. `undefined method for nil:NilClass`. If you are someone who worked with Ruby before, you won't need any explanations here. If not, you might recognize this error on other dynamic, non-compiled languages where you try to call on a method to something you thought would be an object - but in runtime became `nil` for some reason. The disadvantage is that when no checks are performed during compile type (or other stages of evaluations) you are left to debug the program fully in runtime.
4. When executing our programs written in Ruby, the performance was rather limited.

For the reasons we mentioned and some others, we needed a programming language which had all the advantages of Ruby, but without the disadvantages. That's when we discovered Crystal and almost immediately fell in love with it ❤️. Crystal's slick coding experience, ease of lower-level library bindings, type safety in compile-time without the need to even execute the program, and finally the lightning-fast runtime performance gave us what we needed to really set the keyboard on fire! We can honestly say that Crystal gave us the tools to elegantly and efficiently take NexPloit and make it from an idea into a reality.

# How To Make Crystal Even Better
Now let's be fair - we love Crystal, however there is always some room for improvement. One of the challenges we faced with Crystal was the lack of shards (Crystal's "gems") for machine learning and scientific tools. However, expecting other people to add shards is unfair, so we decided to create a shard for [Crystal-FANN](https://github.com/NeuraLegion/crystal-fann) as the groundwork for our needs (and we made it available on our Github page for anyone who may need it). For now, Crystal-FANN seems to hit the spot for us, but we are still considering the addition of Torch or TensorFlow if we conclude that FANN by itself is not enough.

# Summary
Should you try Crystal? Absolutely! Crystal is an amazing language, it is really easy to work with and it produces great results. We definitely recommend Crystal, try it and you will enjoy it for sure!

# Crystal Vs Ruby - Disclaimer
We want to point out that this article is solely our personal experience and opinion regarding why we decided to go with Crystal. We still love Ruby and would highly recommend it to anyone who may have other needs than us. Ruby is well established and has a great supporting community, which is especially useful for programming beginners. And we believe that Ruby has many more great things ahead.

Here is a comparison between some of the parameters which were important to us:


Ruby|Crystal
:---: | :---:
Dynamically typed | Statically typed
Nil reference errors in runtime | Nil reference error checks at compile time
Vast amount of existing libraries | Relatively small amount of existing libraries
Limited runtime performance | Fast runtime performance
Runs in virtual machine | Compiled native code



# Useful Links
[Our website](http://neuralegion.com)

[FANN machine learning library](http://leenissen.dk/fann/wp/)
