---
title: Syntax
description: >
  Crystal’s syntax is heavily inspired by Ruby’s, so it feels natural to read and easy to write, and has the added benefit of a lower learning curve for experienced Ruby devs.
read_more_url: https://crystal-lang.org/reference/getting_started/
read_more_label: Start learning Crystal
tags: syntax
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
