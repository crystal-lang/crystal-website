---
title: Google Summer of Code
description: Enjoy Google Summer of Code 2018 while collaborating with Crystal
section: archive
---

Google Summer of Code is a global program focused on bringing more student
developers into open source software development. Students work with an open
source organization on a 3 month programming project during their break from
school. [read more](https://summerofcode.withgoogle.com/)

## Choose Your Own Adventure

This is a list of some ideas we think might be interesting and
welcome in the community, but we encourage you to propose other projects aligned
with your own interests (as long as they're still related to the Crystal
ecosystem ^_^).

<dl>
  <dt>Benchmarks framework</dt>
  <dd>
    As the compiler and stdlib evolves it's important to know easily if there
    were performance improvements (or unimprovements) due to recent changes.
    The goal would be to build a benchmark framework, the suite of code samples
    to measure, and reporting output that would allow to depict relevant changes
    across Crystal versions.
    <a href="https://github.com/crystal-lang/crystal/issues/5508">read more</a>
  </dd>
  <dt>Crystal bootstrap lineage</dt>
  <dd>
    Originally the Crystal compiler was written in Ruby. At some point it grow
    enough to be bootstrapped and from that moment each releases used the
    previous one. It would be great to have a procedure to rebuild from sources the crystal versions. Most, or all, the information is available in the repository. This would be valuable not only because is neat, but because it would help Crystal to <a href="https://groups.google.com/d/topic/crystal-lang/wYQ5aqdpF3k/discussion">reach other platforms</a>.
  </dd>
  <dt>Put some Windows in Crystal</dt>
  <dd>
    There is ongoing efforts to allow Crystal to work in a native fashion in
    Windows. From tidying up platform agnostic abstractions, to deal with
    specific OS API, representation, and setting bases for CI you can help
    Crystal reach a new land.
  </dd>
  <dt>Documentation &amp; Guides</dt>
  <dd>
    Crystal can serve many purposes. CLI, Gaming, Web apps, UI, etc. For each
    scenario sometimes bindings to C libraries are needed, sometimes guides and
     documentation (and fighting some issues) might be needed. Pick your beloved
     niche and improve the state of art around it.
  </dd>
  <dt>Academy &amp; Science</dt>
  <dd>
    We'd also love to see Crystal flourish in the academy and science. From
    improving low level numeric treatment to improving or creating state of the
    art algorithms used in the area, there are lots of things that can be done.
  </dd>
  <dt>Formality for the good</dt>
  <dd>
    There is no formal document for the semantic of the language. Although there
    are tons of test in the spec of the compiler to ensure things work as
    expected, it would be great to have a proper specification of how the
    language work (or should work). This is not a simple document task.
    Checking if the compiler comply the specs in one of hidden challenges in
    this journey.
  </dd>
  <dt>Meet the shards dependency manager</dt>
  <dd>
    <a href="https://github.com/crystal-lang/shards">Shards</a>
    allows anyone to consume crystal libraries produced by others. Our approach
    is to avoid a centralized repository. Although it's working good enough for
    today uses there are lots of ideas to improve how dependencies are solved,
    fetched and published in order to support more scenarios in the near future.
  </dd>
  <dt>Dig into the compiler</dt>
  <dd>
    Jump into the internals and defeat some <a href="https://github.com/crystal-lang/crystal/issues?q=is%3Aopen+is%3Aissue+label%3Akind%3Abug+label%3Atopic%3Acompiler+sort%3Aupdated-desc">pending issues</a>
    to make the compiler more robust and consistent.
    Note: the compiler is written mostly (~98%) in Crystal.
  </dd>
  <dt>Tidy up the stdlib</dt>
  <dd>
    The compiler and stdlib have evolved across the years.
    Help us <a href="https://github.com/crystal-lang/crystal/issues/5215#issuecomment-340574805">tidy up</a>,
    improve and fix <a href="https://github.com/crystal-lang/crystal/issues?q=is%3Aopen+is%3Aissue+sort%3Aupdated-desc+label%3Atopic%3Astdlib+label%3Akind%3Abug">bugs</a>
    of the stdlib.
  </dd>
  <dt>Database access</dt>
  <dd>
    <a href="https://github.com/crystal-lang/crystal-db">crystal-db</a>
    is the abstraction layer for relational databases as <a href="https://github.com/crystal-lang/crystal-sqlite3/">sqlite</a>,
    <a href="https://github.com/crystal-lang/crystal-mysql">mysql</a>, and <a href="https://github.com/will/crystal-pg/">postgresql</a>.
    Drivers could be added for other databases. Each specific driver could be
    improved. And there are cross cutting concerns that can be tackled in
    <code>crystal-db</code> itself.
  </dd>
  <dt>Web frameworks</dt>
  <dd>
    <a href="http://kemalcr.com/">Kemal</a>, <a href="https://amberframework.org/">Amber</a>,
     and <a href="https://luckyframework.org/">Lucky</a> are some of the top
     options to develop web app, microservices and all kinds of http backed
     services. There are lots of things to do still. Having great frameworks is
     helps to boost productivity and joy while programming. Join and help them
     evolve.
  </dd>
  <dt>New shards</dt>
  <dd>
    Can't think of anything? Check for this community maintained <a href="https://github.com/crystal-community/crystal-libraries-needed/issues?q=is%3Aissue+is%3Aopen+sort%3Aupdated-desc">list of ideas for shards missing</a>
    in the ecosystem.
  </dd>
</dl>

## Next steps

If you are interested, join the [community](/_pages/community.html) through your
channel of preference. You're welcome whether you participate in the Google
Summer of Code or not.

Check the [Google Summer of Code](https://summerofcode.withgoogle.com/)
page to enroll as a student.

Happy crystalling!
