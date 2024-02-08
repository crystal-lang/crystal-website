---
title: Macros
description: >
  Crystal’s answer to metaprogramming is a powerful macro system, which ranges from basic templating and AST inspection, to types inspection and running arbitrary external programs.
read_more: '[Read more about Macros](https://crystal-lang.org/reference/syntax_and_semantics/macros.html)'
---
```crystal
class Object
  def has_instance_var?(name) : Bool
    {% raw %}{{ @type.instance_vars.map &.name.stringify }}{% endraw %}.includes? name
  end
end

class Person
  property name : String

  def initialize(@name)
  end
end

person = Person.new "John"
p! person.has_instance_var?("name") # => true
p! person.has_instance_var?("birthday") # => false
```
