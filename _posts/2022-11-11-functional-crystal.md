---
title: Functional Crystal
summary: A tour on the functional aspects of Crystal
author: beta-ziliani
---

If someone posts a claim "_Crystal is a functional language_", they would be given a grim look. I mean, classes and inheritance are all over the place in the stdlib. Surely it's an object oriented language, right?

If we observe modern programming languages, we'll find that neither functional languages are strictly functional, nor object oriented ones are strictly object oriented. Or, to put it differently, these two concepts are not in contradiction; they can both be part of the tools provided by languages to abstract code. And Crystal is not an exception!

But why should you care? As it turns out, functional programming got fancy these years for several reasons, which can be simplified as:

**<center>Functional programming helps write safe and modular code.</center>**

In this post, we will revisit what makes functional programming exciting, and how Crystal helps you write functional code. In particular, we'll talk about three key components of functional programming:

 1. Immutability.
 2. Algebraic data types.
 3. Closures.

While discussing each of these, we will point out at some improvements that could be made to the compiler and stdlib to improve its support. The intention is not to fix an agenda, but rather to open the discussion about wether such improvements are relevant to the community.

## Mutability considered harmful

A key aspects of functional programming is related to the idea that any change in the state of the program should be _local_. A way to describe this is with the following comparison, where `f` is any function or method, and `x` any value:

```cr
f(x) == f(x)
```

Sounds like this should hold, right? I mean, calling _the same function_ with _the same argument_ should return _the same value_.

<img src="/assets/blog/functional/fx-eq-fx-right.jpg" alt="Anakin showing Padme that f(x) might not be equal to f(x)" class="center"/>

Anakin could show Padme the following function that makes the comparison be false:

```cr
class Counter
  @@count = 0

  def self.count
    @@count += 1
  end
end

def f(x)
  Counter.count
end
```

Changing (_mutating_) the count at each call of `f` is a _non-local effect_, as it doesn't depend on exclusively on `f`'s arguments. You could say that the example above is tricky, but I'm certain that you've experience before the surprised of calling a method and getting an unexpected result.

Several languages that consider themselves functional allow such _non-local effects_. These languages are sometimes mentioned as _multi-paradigm_ or _hybrid_, and an important part of this post is to show that Crystal is also such an hybrid language. It definitively favors OOP, but it also allows important functional patterns.

Indeed, not everything is mutable in Crystal. But before getting there, let's bring an important distinction.

### Values and references

Compilers achieve immutability by passing elements _by value_ (a copy of the value is passed), instead of _by reference_ (the pointer of the value is passed). We'll understand this distinction with some exercises. Consider the following code:

```cr
def f(x : Int32)
  x += 1
end

y = 0
f y
p! y
```

You probably know what it prints: `y # => 0`. Internally, the _value_ of `y` is copied, so when `f` receives `y`, it actually just gets its value. Locally, `f` can do whatever it pleases to that value, `y` will not be affected.

In Crystal, primitive types like numeric types and `struct`s are passed by value.

<!-- If we want to be able to alter the value of `y`, we need to pass it by reference. In Crystal this is doable, but to do it right you need to _box_ it. We won't dicuss this -->

Consider now the following code:

```cr
def g(arr : Array(Int32))
  arr += [1]
  arr = [] of Int32
end

z = [0]
g z
p z
```

What does it print?

<br/>
<br/>
<center>
Space purposefully left blank to let you think.
</center>
<br/>
<br/>

The answer is in the `Array`'s type: it's a `class`, so it's passed _by reference_. That is, changes performed in the array within the function affects `z`. Now, _the reference_ of the array itself (where `z` is located in the memory) is passed by value. Essentially, this means that the array itself is **not** replaced when assigning the empty array to `arr`. Therefore, the answer is `[0, 1]`.

> An instance of a class is passed _by reference_, but the reference itself is passed _by value_.

Crystal distinguishes which objects to pass by reference and which by value with two classes: [Reference](https://crystal-lang.org/api/1.6.2/Reference.html) and [Value](https://crystal-lang.org/api/1.6.2/Value.html). Those classes that inherits from `Reference` are passed by reference, and those that inherit from `Value`, by value.

### Structs, immutable objects

As mentioned previously, instances of `struct`s are passed by value. The following example about 2D points in space shows how structs work:

```cr
struct Point
  getter x : Int32, y : Int32

  def initialize(@x, @y); end
end

def translate_x(point : Point, offset : Int32)
  point.x += offset
  point
end

zero = Point.new 0, 0
ten = translate_x zero, 10
p zero, ten # => Point(@x=0, @y=0)  Point(@x=10, @y=0)
```

Note what's happening here: the function `translate_x` alters the value of the `x` component, and this change works locally: the _new copy_ of the point that is returned has its value altered. See how important immutability is: we _know_ that if we do not change `zero` locally, it will always have the value `(0, 0)`.

Exercise 1: replace `struct` with `class` and see what happens.

Exercise 2: make `translate_x` be an instance method of `struct`, that operates on `@x` of `self` instead of receiving the point. Can you explain what happens?

### Little diversion: the `record` macro

An alternative implementation of the `Point` struct is using the macro [`record`](https://crystal-lang.org/api/1.6.2/toplevel.html#record%28name%2C%2Aproperties%29-macro). This macro further enhances the experience of working with immutable structs.

```cr
record Point, x : Int32 = 0, y : Int32 = 0
```

`record` generates an identical struct as above, together with a handy method `#copy_with` that allows to return a copy of the struct with some given instance variables modified. For instance, we can solve Exercise 2 above defining the `translate_x` method directly when defining `Point`:

```cr
record Point, x : Int32 = 0, y : Int32 = 0 do
  def translate_x(offset : Int32)
    copy_with x: @x + offset
  end
end
```

### Missing bit: Immutable datatypes

Immutability is great to avoid unwilling overwriting of information. However, we can't use structs always to get immutability, because structs do not allow recursive definitions. That is, the following is invalid:

```cr
abstract struct Abstract
end

struct Concrete < Abstract
  getter recursive : Abstract

  def initialize(name, @recursive)
  end
end
```

The error is descriptive:

```text
The struct Concrete has, either directly or indirectly,
an instance variable whose type is, eventually, this same
struct. This makes it impossible to represent the struct
in memory, because the size of this instance variable depends
on the size of this struct, which depends on the size of
this instance variable, causing an infinite cycle.
```

A missing piece of information is that structs are placed in the stack, unlike classes, and that is why the compiler needs to know ahead of time the exact size of it.

If we want to have immutable classes, that are placed in the heap instead of in the stack (and therefore, can have recursive instances), the compiler could add support for it. In a fictional future, we can foresee an `ImmutableReference` class next to `Value` and `Reference` to consider object that are placed in the heap, but that are copied when passed over.

## Exceptions considered harmful

Raising an exception is a costly operation, not only from the performance perspective, but also in terms of safety. Therefore, in functional languages they are looked down upon, and are only used in exceptional situations that aren't expected to be part of the normal course of an application.

A concrete example: a parser. Let's assume it takes a string and produces an element of some type, say `Ast`. A typical definition could start with

```cr
def parse(input : String) : Ast
```

The problem is what to do if there's an error. In very rare situations `input` can be expected to be a well formed string, even more so if it's generated by a human. Therefore, in the normal execution of an application we _must_ expect things to go wrong. We might be tempted to raise an exception, but then, we put the burden of the users of the function: they must read the documentation or take a guess that it will throw an exception (and which one!).

### Return?

One alternative, widely used in the stdlib, is to use a [nilable type](https://crystal-lang.org/reference/1.6/syntax_and_semantics/type_grammar.html#nilable) in the case of failure. In that case, our function will have the following type:

```cr
def parse(input : String) : Ast?  # Note the ending `?`
```

This has an obvious advantage: the user can't ignore that this function might _not_ return an `Ast`. Safer code! Additionally, the stdlib includes methods for easily handling nilable types (🤓 fact: nilable types are _almost_ [option types](https://en.wikipedia.org/wiki/Option_type)).

However, using a nilable type also has an obvious problem: we can't tell what went wrong.

### Return (the exception)

With [union types](https://crystal-lang.org/reference/syntax_and_semantics/type_grammar.html#union) it's easy to provide information about the issues found in the input provided to our parsing function:

```cr
class ParseException < Exception
  getter issue : String
  getter line : Int32
  getter col : Int32
  
  def initialize(@issue, @line, @col)
  end
end

alias ParseResult = Ast | ParseException

def parse(input : String) : ParseResult
```

Now, when using `parse`, we must consider the exception. This is easy to do with a [case statement](https://crystal-lang.org/reference/1.6/syntax_and_semantics/case.html#union-type-checks):

```cr
case result = parse "this is an example"
in Ast
  puts "yay!"
in ParseException
  STDERR.puts "#{result.issue} at #{result.line}:#{result.col}"
end
```

Note the following: we can easily add other possible exceptions. For instance, if we are reading from a file, might want to make a distinction between file errors and parsing ones, we can add the corresponding exception to the union. And since the `case` (as written above) is _exhaustive_, any missing case will fail at compile time.

### Give me the gun, I want to shoot at my foot

Having to `case` at each returned object might sound like a bit too much. No need to suffer: we can mimic the same idea as with `Nil` and extend the `Object` class with a `pure!` method to _assume_ an object is the pure value and not an exception:

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

With this extension we can now assume a call to `parse` won't fail (or the exception will explode in our face!):

```cr
parse("hello").pure!.to_s + " pure world"
```

### The missing bits

The current status of the stdlib and compiler support is missing two things:

 1. **A more functional stdlib**

    The stdlib pervasively raises exceptions, and besides nilable types, has little support for exceptions-as-values. This can be done in baby-steps, like adding the `Object#pure!` and `Object#chain` methods discussed in this post.

 2. Generic aliases

    Right now, type aliases can't be generic. Therefore, it's currently impossible to define a generic `Result` type of the sort:

```cr
alias Result(T) = T | Exception
```

## First-class functions

What is functional programming without lambdas, aka first-class functions? Of course, Crystal has them!

Let's continue the idea that we developed in the previous section. We have a method that might return an exception, and we want to operate with it. We saw already how to use `case` or the new `Object#pure!`; let's see another interesting way. Say we have a functional interface for `File.read_lines`:

```cr
class File
  def self.read_lines(filename : String) : Array(String) | FileException
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
File.read_lines("/tmp/test").chain(&.join.try(&->parse(String)))
```

At first, this might be difficult to parse, in particular for non-crystalists. In essence, `chain` will pass the lines to the block (what's after the first `&`), otherwise it will return the `FileException`. The lines are `join`ed, and the result passed to the `parse` function using the `Object#try` method that simply passes the object to the function. The syntax `&->` allows us to pass a function as argument, when a block is expected.

An alternative form could be using an inline block:

```cr
File.read_lines("/tmp/test").chain {|lines| parse lines.join}
```

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
