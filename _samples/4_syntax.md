---
title: Syntax
description: |
  Crystal’s syntax is heavily inspired by Ruby’s, so it feels natural to read and easy to write, and has the added benefit of a lower learning curve for experienced Ruby devs.
read_more: "[Start learning Crystal](https://crystal-lang.org/reference/getting_started/)"
---
```crystal
class String
  def longest_repetition?
    max = chars
            .chunk(&.itself)
            .map(&.last)
            .max_by?(&.size)

    {max[0], max.size} if max
  end
end

puts "aaabb".longest_repetition? # => {'a', 3}
```
