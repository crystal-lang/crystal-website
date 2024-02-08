---
title: Syntax
description: |
  Crystal’s syntax is heavily inspired by Ruby’s, so it feels natural to read and easy to write, and has the added benefit of a lower learning curve for experienced Ruby devs.
read_more: "[Start learning Crystal](https://crystal-lang.org/reference/getting_started/)"
---
```crystal
def longest_repetition(string)
  max = string
          .chars
          .chunk(&.itself)
          .map(&.last)
          .max_by(&.size)

  max ? {max[0], max.size} : {"", 0}
end

# press ▶️ and check the result
puts longest_repetition("aaabb")
```
