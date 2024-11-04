---
title: Looking through a Crystal the functional paradigm
summary: Crystal's typechecker resembles at times that of modern functional languages. How does it look like to push Crystal's functional capabilities further?
author: beta-ziliani
---

If someone claims "_Crystal is a functional language_", they would be given a grim look. I mean, classes and inheritance are all over the place in the stdlib. Surely it's an object-oriented language, right?

However, language's paradigms are like genders: there are many, and you are not restricted to just have one all the time. And while it's true that Crystal is _mostly_ object-oriented, it has some features that are often associated with functional programming.

<!-- In the functional world, there are two types that are used a lot, the `Maybe` type (aka `Option`) and the `Result` type. They are very useful to deal with nil objects and exceptions, respectively, and this is why they're present in the stdlibs of modern languages. -->

In this post I will explain some functional bits of Crystal, and why you might care. I will also point at missing aspects in Crystal that might help strengthen its functional bits.

I won't expect readers to know functional programming nor Crystal, and I hope the examples will be simple enough for anybody with basic programming background to be able to follow.

## The example

<!-- ## Nil/Null Pointer Exceptions and How To Avoid Them

What have Java, Python, and Ruby in common? Having to deal with nil/null objects properly to avoid crashes. Unless you use [powerful analyzers](https://engineering.fb.com/2022/11/22/developer-tools/meta-java-nullsafe/), or do heavy testing of your functions, your program might pop a nil object all of the sudden. And unless you've did some heavy [defensive programming](https://en.wikipedia.org/wiki/Defensive_programming), your application will certainly crash.

In languages with a type discipline, such as typed functional languages, types identify where those nil objects are, and they force us to consider them. In short: fewer tests needed, little defensive programming required. This is why such languages come with what is known as the `Maybe` or `Option` type (e.g., [Rust](https://doc.rust-lang.org/std/option/), [Scala](https://www.scala-lang.org/api/scala/Option.html), [Haskell](https://hackage.haskell.org/package/base/docs/Data-Maybe.html)).

The idea is the following: when you have an object of a given type, say, a `String`, you know you **have** a string. It can't be nil. And if you _need_ it to be _nillable_, you wrap it in the `Maybe` type: `Maybe(String)`. Crystal doesn't have such type, but have something similar, called _nillable types_. We're going to highlight the differences later.

Maybe types not only help identifying which objects can be nil; it also allows us to avoid raising exceptions. Exceptions are costly, not only from the performance perspective, but also in terms of safety. Therefore, in functional languages they are looked down upon, and are only used in exceptional situations that aren't expected to be part of the normal course of an application. -->

As a running example, we will make a simple parser and point at problems and possible solutions of its implementation. Let's assume it takes a string and produces an element of some type, say `Ast`, that only has two subtypes: `Hello` and `World`. A first attempt could look like:

```cr
abstract class Ast
end

class Hello < Ast
end

class World < Ast
end

def parse(input : String) : Ast
  case input
  when "hello"
    Hello.new
  when "world"
    World.new
  end
end
```

This definition has a problem, and when we try to use the function `parse` the compiler shows it to us:

> ```
> error in line 10
> Error: method ::parse must return Ast but it is returning (Ast | Nil)
> ```

We'll see the details of this error later, but essentially, it's telling us to consider any other case, and not just the two strings `hello` and `world`. When considering the problem in abstract, in very rare situations we can be expect the string to be exactly what we ask for. Therefore, in the normal execution of an application we _must_ expect things to go wrong, and properly handle that situation.

The first possible solution might be to raise an exception:

```cr
class ParseException < Exception
  getter issue : String
  getter line : Int32
  getter col : Int32
  
  def initialize(@issue, @line, @col)
  end
end

def parse(input : String) : Ast
  case input
  ... # same code as before
  else
    raise ParseException.new("Unexpected input: #{input}", 0, 0)
  end
end
```

When using the function, we need to consider the exception:

```cr
def main
  parse "hello"
rescue e : ParseException
  STDERR.puts "#{e.issue} at #{e.line}:#{e.col}"
end
```

This solution works, but it has two drawbacks:

 1. Exceptions are not part of the type: we need to read the documentation or the code in order to find if an exception is raised, and which one.
 2. Exceptions are computationally heavy: they build a stack trace even in cases where traces aren't necessary.

### Return?

An alternative, widely used in Crystal's stdlib, is to use a [nilable type](https://crystal-lang.org/reference/1.14/syntax_and_semantics/type_grammar.html#nilable) in the case of failure. In that case, our function will have the following type:

```cr
def parse(input : String) : Ast?
```

Note the `Ast?` type. This is how we make `Ast` nillable.  This has an obvious advantage: the user can't ignore that this function might _not_ return an `Ast`. Safer code! Additionally, the stdlib includes methods for easily handling nilable types (🤓 fact: nilable types are _almost_ [option types](https://en.wikipedia.org/wiki/Option_type)).

With nillable types we can roll back to our version without the exception:

```cr
def parse(input : String) : Ast?
  case input
  when "hello"
    Hello.new
  when "world"
    World.new
  end
end
```

When calling this function, we need to handle the situation that the string might not be there:

```cr
def main
  input = "hello"
  case parse(input)
  in Ast
    puts "OK"
  in Nil
    puts "The input provided is invalid: #{input}"
  end  
end
```

This solution removes the drawbacks from raising the exception, but now adds a new one: we can't tell what went wrong.

### Return (the exception)

Nillable types are a particular case of [union types](https://crystal-lang.org/reference/syntax_and_semantics/type_grammar.html#union), in which the return type (`Ast` in our case) is extended with another type (`Nil`). Indeed, when we write `Ast?`, the compiler sees `Ast | Nil`. Then, instead of returning `nil` (the implicit object with type `Nil` returned by `parse`), we can return the exception:

```cr
def parse(input : String) : Ast | ParseException
  case input
  ... # same code as before
  else
    ParseException.new("Unexpected input: #{input}", 0, 0)
  end
end
```

Our `main` function changes to:

```cr
def main
  result = parse "hello"
  case result
  in Ast
    puts "OK"
  in ParseException
    STDERR.puts "#{result.issue} at #{result.line}:#{result.col}"
  end
end
```

Note the following: we can easily add other possibles exceptions to the union. For instance, if we are reading from a file, might want to make a distinction between file errors and parsing ones. Then, we add `IO::Error` to the returning type, and since the `case` (as written above) is _exhaustive_, any missing case will fail at compile time.

### Give me the gun, I want to shoot at my foot

Having to `case` at each returned object might sound like a bit too much. No need to suffer: we can mimic the same idea as with `Nil`'s [`not_nil!`](https://crystal-lang.org/api/1.14.0/Object.html#not_nil%21-instance-method) method, and extend the `Object` and `Eception` classes with a `pure!` method to _assume_ a value exists and is not an exception:

```cr
class Object
  def pure! : self
    self
  end
end

class Exception
  def pure! : NoReturn
    raise self
  end
end
```

With this extension we can assume calling `parse` won't fail (or the exception will explode in our face!):

```cr
parse("hello").pure!
```

<!-- ### The missing bits

The current status of the stdlib and compiler support is missing two things:

 1. **A more functional stdlib**

    The stdlib pervasively raises exceptions, and besides nilable types, has little support for exceptions-as-values. This can be done in baby-steps, like adding the `Object#pure!` and `Object#chain` methods discussed in this post.

 2. Generic aliases

    Right now, type aliases can't be generic. Therefore, it's currently impossible to define a generic `Result` type of the sort:

```cr
alias Result(T) = T | Exception
```
-->

## First-class functions

What is functional programming without lambdas, aka first-class functions? Of course, Crystal has them!

Let's continue the idea that we developed in the previous section. We have a method that might return an exception, and we want to operate with it. We saw already how to use `case` or the new `Object#pure!`; let's see another interesting way. Say we have a functional interface for `File.read_lines`:

```cr
class File
  def self.read_lines(filename : String) : Array(String) | IO::Error
    # Code to read the file, returning the exception if there's a problem
  end
end
```

Next, we extend again `Object` and `Exception`, this time to add a new `chain` method that will allow us to chain calls to functions returning exceptions.

```cr
class Object
  def chain(&)
    yield self
  end
end

class Exception
  def chain(&)
    return self
  end
end
```

Together, we can read a file, join its lines, and then parse it with:

```cr
File.read_lines("/tmp/test").chain {|lines| parse lines.join(" ")}
```

At first, this might be difficult to parse, in particular for non-crystalists. In essence, `chain` will pass the lines to the block (what's between `{}`), otherwise it will return the `IO::Error`. The lines are `join`ed, and the result passed to the `parse` function.

## Algebraic Data Types and pattern matching

A union type returning two different types of objects like `ParseResult` is similar in essence to an _algebraic data type_ (ADT). ADTs allow constructing a type from a defined set of _constructors_ or, in our case, objects. That is, we know from the type alias definition that a `ParseResult` can only be an `Ast` or a `ParseException`, and nothing else. This enables a particular form of reasoning called _pattern matching_.

In order to present the main ingredients of working with ADTs we present a problem and compare the OOP solution with the functional one.

### The problem

Let's build the model for `Food`. A `Food` can be either a `Compound` or a `Base` ingredient. For instance, a "chocolate with caramel filling" has cacao, milk, sugar, and caramel, the latter being also a compound of cream, butter, and sugar.

```cr
abstract class Food
  getter name : String

  def initialize(@name)
  end
end

class Base < Food
end

class Compound < Food
  getter ingredients : Array(Food)

  def initialize(name, @ingredients)
    super name
  end
end
```

We want to have a nice printing of this elements overriding `#to_s`. How do we proceed?

### The OOP approach: make each object responsible

The typical OOP pattern is to make each child class responsible:

```cr
class Base < Food
  def to_s(io)
    io << name
  end
end

class Compound < Food
  def to_s(io)
    io << name << " ("
    ingredients.each_with_index do |f, i|
      io << ", " unless i == 0
      f.to_s io
    end
    io << ")"
  end
end
```

Note how we are leaving to the compiler the task of deciding which method to call when calling `f.to_s` for each element in `ingredients` (🤓 fact: Crystal uses [multiple dispatch](https://en.wikipedia.org/wiki/Multiple_dispatch)).

This pattern has a main advantage: if we extend tomorrow the class of `Food` with another type, we can easily do it without changing any of the existing code.

As a disadvantage, in cases in which we are unlikely going to have more subclasses, this pattern obscures the algorithm: If each subclass lies in different places of a file, or more so, in different files, we need to jump through the code to find precisely what it does.

A simple, _functional_ in style alternative is to use `case` (a simple form of _pattern-matching_).

### The functional approach: pattern-matching

With the `case` statement we can directly code the `#to_s` in `Food`. This is a more general example than what we saw above with `ParseResult`, but this time recusively traversing the structure of a `Food`.

```cr
abstract class Food
  def to_s(io)
    case self
    in Base
      io << name
    in Compound
      io << name << " ("
      self.ingredients.each_with_index do |f, i|
        io << ", " unless i == 0
        f.to_s io
      end
      io << ")"
    end
  end
end
```

The algorithm is now in one place. Note that, in essence, what we're doing is making the multiple dispatch explicit.

## The missing bit: Improved pattern-matching

Right now, pattern-matching is quite basic: it only works on types, and can't be refined to the field values of the object. Consider if we want to distinguish some food. For instance, imagine we have a `#sugar` percentage field in `Compound`, and we want to print a warning when it's above some threshold.  It would be nice to be able to do the following:

```cr
case self
in Compound where self.sugar > Food::SUGAR_ALLOWED
  io << name << " (HIGH IN SUGARS)"
  ... # code to print the ingredients
in Compound
  ... # normal case
in Base
  ... # case for Base
end
```

Also: the exhaustive checker of `case` in the example [requires a case for the abstract class `Food`](https://github.com/crystal-lang/crystal/issues/12796).

## Concluding remarks

Crystal already lets you take good advantage of some functional patterns, and a full functional experience is not that far away. Of course, mature functional languages have years ahead optimizing for such patterns, but that shouldn't worry us: for performance, we can resort to good ol' mutation! That's the beauty of multi-paradigm languages.

Here we also draw attention about what can be done to get a bit closer to the functional paradigm, without giving up the nice OOP, open paradigm of our language.
