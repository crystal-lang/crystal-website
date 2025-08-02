---
title: Flow typing
short_name: Flow typing
description: |
  The compiler tracks the type of variables at each point,
  and restricts types according to conditions.
---
```crystal
loop do
  case message = gets # type is `String | Nil`
  when Nil
    break
  when ""
    puts "Please enter a message"
  else
    # In this branch, `message` cannot be `Nil` so we can safely call `String#upcase`
    puts message.upcase
  end
end
```
