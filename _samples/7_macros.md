---
title: Macros
description: >
  Crystal’s answer to metaprogramming is a powerful macro system, which ranges from basic templating and AST inspection, to types inspection and running arbitrary external programs.
read_more: '[Read more about Macros](https://crystal-lang.org/reference/syntax_and_semantics/macros.html)'
---
{% raw %}

```crystal
macro upcase_getter(name)
  def {{ name.id }}
    @{{ name.id }}.upcase
  end
end

class Person
  upcase_getter name

  def initialize(@name : String)
  end
end

person = Person.new "John"
person.name # => "JOHN"
```

{% endraw %}
