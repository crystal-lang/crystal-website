---
short_name: Types
title: Type system
description: |
  The compiler catches type errors early. Avoid the [billion-dollar mistake](https://www.infoq.com/presentations/Null-References-The-Billion-Dollar-Mistake-Tony-Hoare).

  The code is still clean and feels like a dynamic language.
read_more: "[More about the type system](https://crystal-lang.org/reference/syntax_and_semantics/types_and_methods.html)"
---
```crystal
def add(a, b)
  a + b
end

add 1, 2         # => 3
add "foo", "bar" # => "foobar"
```
