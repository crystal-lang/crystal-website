---
short_name: Types
title: Type system
description: |
  The compiler catches type errors early. Avoids null pointer exceptions at runtime.

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
