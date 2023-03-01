---
title: "Heads up: Crystal is upgrading its Regex engine"
author: beta-ziliani
summary: "Crystal is upgrading from PCRE to PCRE2"
---

Crystal uses since its inception the [PCRE](https://www.pcre.org/) library for dealing with regular expressions. This library has two major versions, and Crystal so far resorted to the first one (PCRE). However, this version reached its end of life. Therefore, for the next release (1.8) we are planning to move to its successor, PCRE2.

## PCRE vs PCRE2

The two library versions, PCRE and PCRE2 are mostly compatible with each other. There are some small differences which can cause breaking changes. But we don't expect many bumps on the ride. Most notably, PCRE2 is stricter than PCRE in some edge cases. This means that PCRE might have accepted some invalid regexes, but PCRE2 will not allow them.

Unfortunately there's [no guide](https://github.com/PCRE2Project/pcre2/issues/51) to help with the porting. The most documented list of changes is [this thread](https://stackoverflow.com/questions/70273084/regex-differences-between-pcre-and-pcre2) on Stackoverflow.

On the plus side, PCRE2 have extended support for interesting features. You can read more about its features in this [Wikipedia article](https://en.wikipedia.org/wiki/Perl_Compatible_Regular_Expressions) or in the [project documentation](https://www.pcre.org/).

## Validation of regex literals

In order to comprehend the roadmap below, it is important to establish an existing difference between the compiler and the stdlib regarding regexes. When you write something like `/(a|b)*/.match "abba"`, the _compiler_ checks the validity of the regex literal (`/(a|b)/`). An invalid expression would result in a syntax error. Then, when executing the program, the _stdlib_ bindings to the regex library will perform the actual execution of the matching.

This difference has a consequence: it is possible to check regex literals with one library and then execute them with another.

In the last release (1.7) we already added the possibility to opt-in to PCRE2 **in the stdlib** with a [compiler flag](https://crystal-lang.org/reference/1.7/syntax_and_semantics/literals/regex.html). That means that if you have 1.7 and PCRE2 installed in your system, you can compile your program or shard with `-Duse_pcre2` and then execute it to see if any of the regexes fail at runtime.  If a regex fails, then it must be rewritten to be compliant with PCRE2.

In the coming release, PCRE2 will be used by the compiler and the stdlib by default. It will be possible to use PCRE in _stdlib_ still with the compiler flag `-Duse_pcre` in case something brakes. But the compiler will always use PCRE2 to validate regex literals. This is important for consistency because it directly affects the syntax of Crystal.

If you need to keep using the old PCRE and the compiler considers a literal as invalid due to restrictions in PCRE2, you can convert the literal into a `Regex.new` call which receive the expression as a string literal. For performance reasons it's recommended to cache the `Regex` instance (for example in a constant).

## Migrating your project to PCRE2

We're still more than a month away from 1.8, giving us time to introduce the changes into the nightly builds and to let the community test their shards and projects for incompatibilities.

So, to be prepared, we suggest you to:

 1. If you are using 1.7, use the compiler flag `-Duse_pcre2` to check how your project fares.

 2. If you are using nightlies, they already use PCRE2. To get the old behavior, you need to add `-Duse_pcre` (remember this _only affects runtime_ behavior, not the syntax or regex literals).

 3. Fix every regex that is causing trouble, if any.

 4. Remove `-Duse_pcre` if you added it in 2: support for PCRE will not be guaranteed after 1.9.

Keep us posted if your project fails because of this change.  We'll gather the information and possible fixes for others facing similar issues.

> **NOTE:** ⚠️ Package maintainers ⚠️
> Please switch to PCRE2 no later than in 1.8.
