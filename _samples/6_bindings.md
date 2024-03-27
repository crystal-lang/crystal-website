---
title: C-bindings
description: |
  Crystal allows to define bindings for C libraries and call into them.
  You can easily use the vast richness of library ecosystems available.

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

# This example intentionally uses a simple standard C function to be succinct.
# Of course you could do *this specific* calculation in native Crystal as well:
# 2.0 ** 4.0 # => 16.0
```
