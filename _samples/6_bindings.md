---
title: C-bindings
description: |
  Bindings for C libraries makes it easy to use existing tools.
  Crystal calls lib functions natively without any runtime overhead.

  No need to implement the entire program in Crystal when there are already
  good libraries for some jobs.
read_more: '[Learn how to bind to C libraries](https://crystal-lang.org/reference/syntax_and_semantics/c_bindings/)'
---
```crystal
# Define the lib bindings and link info:
@[Link("m")]
lib LibM
  fun pow(x : LibC::Double, y : LibC::Double) : LibC::Double
end

# Call a C function like a Crystal method:
puts LibM.pow(2.0, 4.0) # => 16.0
```
