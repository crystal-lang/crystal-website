---
title: Null reference checks
short_name: Nil checking
description: |
  `nil` values are represented by a special type, `Nil`, and any value that *can* be
  `nil` has a union type including `Nil`.

  As a consequence, the compiler can tell whether a value is nilable at compile
  time. It enforces explicit handling of `nil` values, helping prevent the dreadful [billion-dollar mistake](https://www.infoq.com/presentations/Null-References-The-Billion-Dollar-Mistake-Tony-Hoare).
---
```crystal
foo = [nil, "hello world"].sample

# The type of `foo` is a union of `String` and `Nil``
puts typeof(foo) # => String | Nil

# This would be a type error:
# puts foo.upcase # Error: undefined method 'upcase' for Nil

# The condition excludes `Nil` and inside the branch `foo`'s type is `String`.
if foo
  puts typeof(foo) # => String
  puts foo.upcase
end
```
