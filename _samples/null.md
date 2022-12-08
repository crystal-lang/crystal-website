---
title: Null reference checks
short_name: Nil checking
description: >
  All types are non-nilable in Crystal, and nilable variables are represented as a union between the type and nil. As a consequence, the compiler will automatically check for null references in compile time, helping prevent the dreadful [billion-dollar mistake](https://www.infoq.com/presentations/Null-References-The-Billion-Dollar-Mistake-Tony-Hoare).
tags: null-ref
---
```crystal
# press play and see the error that the compiler throws
if rand(2) > 0
  my_string = "hello world"
end

puts my_string.upcase
```
