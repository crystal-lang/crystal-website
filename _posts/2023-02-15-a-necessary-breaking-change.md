---
title: "A necessary breaking change in the Regex engine"
author: beta-ziliani
summary: "PCRE is at EOL, we need to move to PCRE2"
---

Crystal uses since its inception the [PCRE](https://www.pcre.org/) library for dealing with regular expressions. This library has two major versions, and Crystal so far resorted to the first one (PCRE). However, this version is getting at its end of life. Therefore, for the next release (1.8) we are moving to its successor, PCRE2.

In the last release (1.7) we already added the possibility to use PCRE2 with a [compiler flag](https://crystal-lang.org/reference/1.7/syntax_and_semantics/literals/regex.html). You can check your project compatibility by adding `-Duse_pcre2` to your compilation flags, and running the regexes. If they don't fail, you're likely in the safe side.

But note: in the coming release the PCRE2 validity of regex literals will be done at compile time, like today it's done for PCRE. So even if your project compiles and run with `-Duse_pcre2`, it might still fail compilation in 1.8.

The two libraries, PCRE and PCRE2, have small differences. Most notably, and where we expect most of the friction to come with this change, is that PCRE2 is stricter than PCRE. This means that it will mark as incorrect regexes that were working in PCRE.

Unfortunately there's [no guide](https://github.com/PCRE2Project/pcre2/issues/51) to help with the porting. The most documented list of changes is [this thread](https://stackoverflow.com/questions/70273084/regex-differences-between-pcre-and-pcre2) in Stackoverflow. On the plus side, PCRE2 have extended support for interesting features. You can read that in the [documentation]().
