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

## Values and references

Compilers achieve immutability passing elements _by value_ instead of _by reference_. Consider the following code:

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
  arr[0] += 1
  arr = [2]
end

z = [0]
g z
p z
```

What does it print?

<br/>
<br/>
<center>
Space purposedly left in blank to let you think.
</center>
<br/>
<br/>

The answer is in the `Array`'s type: it's a `class`, so it's passed _by reference_. That is, changes performed in the array within the function affects `z`. Now, _the reference_ of the array itself (where `z` is located in the memory) is passed by value. Essentially, this means that the array itself is **not** replaced when assigning the array `[2]` to `arr`. Therefore, the answer is `[1]`.

> An instance of a class is passed _by reference_, but the reference itself is passed _by value_.

Crystal distinguishes which objects to pass by reference and which by value with two classes: [Reference](https://crystal-lang.org/api/1.6.2/Reference.html) and [Value](https://crystal-lang.org/api/1.6.2/Value.html). Those classes that inherits from `Reference` are passed by reference, and those that inherit from `Value`, by value.

## Structs, immutable objects

As mentioned previously, there is a special type of object that is passed as value: instances of `struct`s. The following example about 2D points in space shows how structs work:

```cr
struct Point
  property x : Int32, y : Int32

  def initialize(@x, @y); end
end

def translate_x(point : Point, x : Int32)
  point.x += x
  point
end

zero = Point.new 0, 0
ten = translate_x zero, 10
p zero, ten # => Point(@x=0, @y=0)  Point(@x=10, @y=0)
```

Note what's happening here: the function `translate_x` alters the value of the `x` component, and this change works locally: the _new copy_ of the point that is returned has its value altered. See how important it is immutability: we _know_ that if we do not change locally `zero`, it will always have the value `(0, 0)`.

## Exceptions considered harmful

Raising an exception is a costly operation, not only from the performance perspective, but also in terms of safety. Therefore, in functional languages they are looked down upon, and are only used in exceptional situations that aren't expected to be part of the normal course of an application.

A concrete example: a parser. Let's assume it takes a string and produces an element of some type, say `Ast`. A typical definition could start with

```cr
def parse(input : String) : Ast
```

The problem is what to do if there's an error. In very rare situations `input` can be expected to be a well formed string, even more so if it's generated by a human. Therefore, in the normal execution of an application we _must_ expect things to go wrong. We might be tempted to raise an exception explaining what went wrong, but then, we put the burden of the users of the function: they must read the documentation or take a guess that it will throw an exception (and which one!).

### Return?

One alternative, widely used in the stdlib, is to use a [nilable type](https://crystal-lang.org/reference/1.6/syntax_and_semantics/type_grammar.html#nilable) in the case of failure. In that case, our function will have the following type:

```cr
def parse(input : String) : Ast?  # Note the ending `?`
```

This has an obvious advantage: the user can't ignore that this function might _not_ return an `Ast`. Safer code! Additionally, the stdlib includes methods for easily handling nilable types (🤓 fact: nilable types are _almost_ [option types](https://en.wikipedia.org/wiki/Option_type)).

However, using a nilable type also has an obvious problem: we can't tell what went wrong.

### Return the exception

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
parse("hello").pure! + " world"
```

## Closures

What is functional programming without lambdas, aka first-class functions or lambdas? Of course, Crystal has them!

Let's continue the idea that we developed in the previous section. We have a method that might return an exception, and we want to operate with it. We saw how to use `case` or the created `Object#pure!`, let's see another interesting way. Say we have a functional interface for `File.read_lines`:

```cr
class File
  def self.read_lines(filename : String) : Array(String) | FileException
    # Code to read the file, returning the exception if there's a problem
  end
end
```

Next, we extend `Object` again, this time to add a new `chain` method that will allow us to chain calls to functions returning exceptions.

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
File.read_lines("/tmp/test").chain(&.join.chain(&->parse(String)))
```

## Algebraic Data Types

A union type returning two different types of objects like `ParseResult` can be considered a particular case of an _algebraic data type_ (ADT). ADTs allow constructing a type from a defined set of _constructors_ or, in our case, objects. That is, we know from the type that a `ParseResult` can only be an `AST` or a `ParseException`, and nothing else. This enables a particular form of reasoning that is different from what we see in OOP.

In order to present the main ingredients of working with ADTs, we will compare it with a typical OOP pattern.

### The Visitor Pattern

The compiler of Crystal uses the [visitor pattern](https://en.wikipedia.org/wiki/Visitor_pattern) for working with the abstract syntax tree of the language. The following is a simplified example. We start presenting the classes that form the syntax tree, consisting of binary operators (like `+`, `-`, etc.) and integer values. They all consist of

```cr
abstract class Ast
end

class BinOp < Ast
  getter operator : String
  getter left : Ast, right : Ast

  def initialize(@operator, @left, @right)
  end
end

class IntLiteral < Ast
  getter number : Int32

  def initialize(@number)
  end
end
```

Now we can define the visitor: a class that operates on `Ast` objects. We create a visitor to print

```cr
abstract class AstVisitor
  abstract def visit(binop : BinOp)

  abstract def visit(int : IntLiteral)
end

class PrintVisitor < AstVisitor
  def initialize(@io : IO)
  end
  
  def visit(binop : BinOp)
    visit(binop.left)
    binop.operator.to_s @io
    visit(binop.right)
  end
  
  def visit(int : IntLiteral)
    int.number.to_s @io
  end
end

abstract class Ast
  def to_s(io)
    PrintVisitor.new(io).visit(self)
  end
end

  
BinOp.new("+", IntLiteral.new(1), IntLiteral.new(2)).to_s STDOUT
```

## The missing bits

We've seen that Crystal has good support for functional programming. But there are a few improvements that could make for a better developing experience.

### A more functional stdlib

The stdlib pervasively raises exceptions, and besides nilable types, has little support for exceptions-as-values.

### Better type inference for closures

It's possible to create a closure and assign it to a variable with the following syntax:

```cr
double = ->(x : Int32) { 2 * x }

p 3.try(&double).try(&double) # => 12
```

Unfortunately, we need to be explicit about the type of the input parameters in the closure (in this case, `Int32`). While it could be guessed from the context, as with a regular function or method, Crystal won't infer it. It's not a critical aspect, but following the same —let me add, _beautiful_— ergonomics of the language would be a nice touch.

### Generic aliases

It's possible in Crystal to build
