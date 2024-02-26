---
short_name: Typing
title: Type system
description: |
  Crystal is statically typed and type errors are caught early by the compiler,
  eliminating a range of type-related errors at runtime.

  Yet type annotations are rarely necessary, thanks to powerful type inference.
  This keeps the code clean and feels like a dynamic language.
read_more: "[More about the type system](https://crystal-lang.org/reference/syntax_and_semantics/types_and_methods.html)"
---
```crystal
def shout(x)
  # Notice that both Int32 and String respond_to `to_s`
  x.to_s.upcase
end

# If `ENV["FOO"]` is defined, use that, else `10`
foo = ENV["FOO"]? || 10

puts typeof(foo) # => (Int32 | String)
puts typeof(shout(foo)) # => String
```
