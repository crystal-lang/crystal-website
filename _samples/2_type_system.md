---
title: Type system
description: |
  Crystal is statically type checked, so any type errors will be caught early by the compiler rather than fail on runtime. Moreover, and to keep the language clean, Crystal has built-in type inference, so most type annotations are unneeded.
read_more: "[Read more about Crystal's type system](https://crystal-lang.org/reference/syntax_and_semantics/types_and_methods.html)"
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
