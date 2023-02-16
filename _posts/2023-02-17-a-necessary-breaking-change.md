---
title: "A necessary breaking change in the Regex engine"
author: beta-ziliani
summary: "PCRE is at EOL, we need to move to PCRE2"
---

Crystal uses since its inception the [PCRE](https://www.pcre.org/) library for dealing with regular expressions. This library has two major versions, and Crystal so far resorted to the first one (PCRE). However, this version is getting at its end of life. Therefore, for the next release (1.8) we are planning to move to its successor, PCRE2.

In order to comprehend the roadmap below, it is important to establish an existing difference between the compiler and the stdlib regarding regexes. When you write something like `/(a|b)*/.match "abba"`, the _compiler_ checks the validity of the regex literal. Since its a valid regex expression, it will compile the program successfully. Then, when executing the program, the _stdlib_ bindings to the regex library will perform the actual execution of the matching.

This difference has a consequence: it is possible to check regex literals with one library and then execute them with another.

The two libraries, PCRE and PCRE2, have small differences. Most notably, and where we expect most of the friction to come with this change, is that PCRE2 is typically stricter than PCRE. This means that it will mark as incorrect regexes that were working with PCRE.

Unfortunately there's [no guide](https://github.com/PCRE2Project/pcre2/issues/51) to help with the porting. The most documented list of changes is [this thread](https://stackoverflow.com/questions/70273084/regex-differences-between-pcre-and-pcre2) in Stackoverflow. On the plus side, PCRE2 have extended support for interesting features. You can read more about its features in this [Wikipedia article](https://en.wikipedia.org/wiki/Perl_Compatible_Regular_Expressions) or in the [project documentation](https://www.pcre.org/).

In the last release (1.7) we already added the possibility to use PCRE2 **in the stdlib** with a [compiler flag](https://crystal-lang.org/reference/1.7/syntax_and_semantics/literals/regex.html). That means that if you have 1.7 and PCRE2 installed in your system, you can compile your program or shard with `-Duse_pcre2` and then execute it to see if any of the regexes fail at runtime.  If a regex fails, then it must be rewritten to be compliant with PCRE2.

In the coming release, PCRE2 will be used by the compiler and the stdlib by default. It will be possible to use PCRE still (`-Duse_pcre`), but the compiler binaries will use PCRE2 to validate regex literals. If you want to keep using the old PCRE, you'll have to compile the compiler itself with this flag.

We're still 50 days from 1.8, giving us time to introduce the changes into the nightly builds and to let the community test their shards and projects for incompatibilities. If we find the breakage is too big and that we need more time to process it, then we'll revert it before the release and push it for 1.9.

So, to be prepared, the next steps are:

 0. If you are using 1.7, add `-Duse_pcre2` to check how your project fares.

 1. If you are using nightlies, they already have [PR](https://github.com/crystal-lang/crystal/pull/12978) merged, meaning that you don't need to add the flag. You will need to add `-Duse_pcre` to get the old behavior, _but only at runtime!_.

 2. The compiler will use PCRE2 (PR pending). This means that projects that compile on nightlies might see failures when _compiling_ regexes.

Keep us posted if your project fails because of this change.  We'll gather the information and possible fixes for others facing similar issues.
