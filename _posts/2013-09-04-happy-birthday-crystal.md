---
title: Happy birthday, Crystal!
thumbnail: h!
summary: Crystal is one year old
author: asterite
---

Yesterday Crystal became one year old. Yay! :-)

A lot of things happened since the moment we started this rather ambitious project, and there is still
a lot more to do.

Although its syntax is very similar to Ruby, there are many differences, and every day the distance
is growing bigger.

Here's a summary of what we have in the language right now.

## Efficient code generation

Crystal is **not** interpreted. It doesn't have a virtual machine. The code is compiled to
native machine code by using LLVM.

You don't specify the types of variables, instance variables or method arguments,
like is usually done in statically compiled languages. Instead, Crystal tries to be as
smart as possible and infers the types for you.

## Primitive types

Primitive types map to native machine types.

```ruby
true    # Bool
1       # Int32
1_u64   # UInt64
1.5     # Float64
1.5_f32 # Float32
'a'     # Char
```

## ASCII Strings

They come in many flavors, like in Ruby, and they also support interpolation.

```ruby
a = "World"
b = "Hello #{a}" #=> "Hello World"
```

We still need to decide what's the best way to deal with different encodings, so this
is just a temporary implementation.

Did you know that [String](https://github.com/crystal-lang/crystal/blob/master/src/string.cr)
is implemented in Crystal itself? There's just very small magic to make it have the
size and pointer to the chars buffers, but everything else is built on top of that.

## Symbols

```ruby
:foo
```

At runtime, each symbol is represented by a unique integer. A table of integer to string is built for
implementing Symbol#to_s (but there's no way right now to do String#intern).

## Union types

You don't need to specify the type of a variable. If it is assigned multiple types,
it will have those types at compile-time. At run-time it will have only one.

```ruby
if some_condition
  a = 1
else
  a = 1.5
end

# Here a can be an Int32 or Float64

a.abs  # Ok, both Int32 and Float64 define the 'abs' method without arguments
a.succ # Error, Float64 doesn't have a 'succ' method
```

You can use "is_a?" to check for a type:

```ruby
if a.is_a?(Int32)
  a.succ # Ok, here a can only be an Int32
end
```

You can even use "responds_to?":

```ruby
if a.responds_to?(:succ)
  a.succ # Ok
end
```

## Methods

In Crystal methods can be overloaded. The overloads come from the number of arguments,
type restrictions and *yieldness* of a method.

```ruby
# foo 1
def foo(x, y)
  x + y
end

# foo 2
def foo(x)
end

# foo 3
def foo(x : Float)
end

def foo(x)
  yield
end

foo 1, 1      # Invokes foo 1
foo 1         # Invokes foo 2
foo 1.5       # Invokes foo 3
foo(1) { }    # Invokes foo 4
```

Contrast this with having to check **at runtime** the number of arguments of the method,
whether a block was given, or which are the types of arguments: we believe this is much more
readable and efficient.

Also, there's no "wrong number of arguments" exception thrown at runtime: in Crystal
it's a compile time error.

The last bit, overloading based on whether a method yields or not, will probably change
and needs to be re-thought.

## Classes

No need to specify the types of instance variables, but all types assigned to
an instance variable will make that variable have a union type.

```ruby
class Foo
  # We prefer getter, setter and property over
  # attr_reader, attr_writer and attr_accessor
  getter :value

  # Note the @value at the argument: this is similar to Coffeescript
  # and we think it's a nice syntax addition.
  def initialize(@value)
  end
end

foo = Foo.new(1)
foo.value.abs # Ok

# At this point @value is an Int32

foo2 = Foo.new('a')

# Because of the last line, @value is now an Int32 or Char.
# Char doesn't have an 'abs' method, so a compile time error is issued.
```

If you really need different Foo classes with different types for @value,
you can use a generic class:

```ruby
class Foo(T)
  getter :value

  def initialize(@value : T)
  end
end

foo = Foo.new(1)    # T is inferred to be an Int32, and foo is a Foo(Int32)
foo.value.abs       # Ok

foo2 = Foo.new('a') # T is inferred to be a Char, and foo2 is a Foo(Char)
foo2.value.ord            # Ok

# You can also explicitly specify the generic type variable
foo3 = Foo(String).new("hello")
```

Array and Hash are generic classes too, but they can also be constructed using
literals. When elements are specified, the generic type variables are inferred.
If no element is specified, you have to tell Crystal the generic type variables.

```ruby
a = [1, 2, 3]            # a is an Array(Int32)
b = [1, 1.5, 'a']        # b is an Array(Int32 | Float64 | Char)
c = [] of String         # c is an Array(String), same as doing Array(String).new

d = {1 => 2, 3 => 4}     # d is a Hash(Int32, Int32)
e = {} of String => Bool # e is a Hash(String, Bool), same as doing Hash(String, Bool).new
```

And yes, [Array](https://github.com/crystal-lang/crystal/blob/master/src/array.cr) and
[Hash](https://github.com/crystal-lang/crystal/blob/fd6c0238f6e7725d307d4c010d8c860e38a46d72/std/hash.cr) are completely
implemented in Crystal. This makes it very easy for anyone to collaborate on those classes.

We really wanted to avoid having to specify type variables. In fact, we wanted to
avoid having to differentiate between generic and non-generic classes. We spent
a long time (maybe three months?) trying to make it work **efficiently** but we couln't.
Maybe it doesn't have an efficient solution. At least we didn't find anyone who was
able to do it. Generic types are a small sacrifice, but in return we get much
faster compile times.

## Modules

Of course, modules are also present in Crystal, and they can also be generic.

## Blocks

For now, blocks can't be saved to a variable or passed to another method. That means,
we still lack closures. It's not an easy thing to do if we want a smart type inference,
so we need some time to think it over.

## Bindings to C

You can declare bindings to C in Crystal, no need to use C, make wrappers or
use another language. For example, this is part of the SDL binding:

```ruby
lib LibSDL("SDL")
  INIT_TIMER       = 0x00000001_u32
  INIT_AUDIO       = 0x00000010_u32
  # ...
  struct Rect
    x, y : Int16
    w, h : UInt16
  end
  # ...
  union Event
    type : UInt8
    key : KeyboardEvent
  end
  # ...
  fun init = SDL_Init(flags : UInt32) : Int32
end

value = LibSDL.init(LibSDL.INIT_TIMER)
```

## Pointers

You can allocate memory and interface with C by having Pointers as a type in the language.

```ruby
values = Pointer(Int32).malloc(10) # Ask for 10 ints
```

## Regular expressions

Regular expressions are implemented, for now, with C bindings to the PCRE library. Again,
`Regexp` is entirely written in Crystal.

```ruby
"foobarbaz" =~ /(.+)bar(.+)/ #=> 0
$1                           #=> "foo"
$2                           #=> "baz
```

## Ranges

Once again, [implemented in Crystal](https://github.com/crystal-lang/crystal/blob/master/src/range.cr).

## Exceptions

You can raise and rescue exceptions. They are implemented using libunwind. We are still lacking line
numbers and filenames in the stacktraces.

## Exporting C functions

You can declare functions to be exported to C, so you can compile Crystal code and use it in C
(although there's still no compiler flag to generate an object file, but it should be easy to implement).

```ruby
fun my_c_function(x : Int32) : Int32
  "Yay, I can use string interpolation and call it #{x} times from C"
end
```

## Macros

This is an experimental feature of the language where you can generate source code
from AST nodes.

```ruby
macro generate_method(name, value)
  "
  def #{name}
    #{value}
  end
  "
end

generate_method :foo, 1

puts foo # Prints: 1
```

The macros getter, setter and property are implemented in a similar way, but we've
been thinking of a more powerful and simpler way to achieve the same thing so this
feature might disappear.

## Yield with scope

Similar to yield, but changes the implicit scope of the block.

```ruby
def foo
  # -1 becomes the default scope where methods
  # are looked up in the given block
  -1.yield(2)
end

foo do |x|
  # Invokes "abs" on -1
  puts abs + x #=> 3
end
```

This allows writing powerful DSLs with zero overhead: no allocations or closures
are involved.

Something similar can be achieved in Ruby with instance_eval(&block), but for now
we find it easier to implement it this way, and maybe easier to use.

## Specs

We'be built a [very small clone of RSpec](https://github.com/crystal-lang/crystal/blob/master/src/spec.cr) and we are using it to test the standard
library as well as the new compiler. Here's a sample spec for the Array class:

```ruby
require "spec"

describe "Array" do
  describe "index" do
    it "performs without a block" do
      a = [1, 2, 3]
      a.index(3).should eq(2)
      a.index(4).should eq(-1)
    end

    it "performs with a block" do
      a = [1, 2, 3]
      a.index { |i| i > 1 }.should eq(1)
      a.index { |i| i > 3 }.should eq(-1)
    end
  end
end
```

So Crystal makes it extremely easy to write tests, and at the same time gives you type safety.
The best of both worlds.

## Roadmap

There are a lot more things to implement and we have many ideas to try out.

<ul class="goals">
  <li>We still need a Garbage Collector, and we want an efficient, concurrent one.</li>
  <li>We want to have concurrency primitives, similar to Erlang or Go.</li>
  <li>We want to have better metaprogramming.</li>
  <li>We might have structs, not only for C bindings, to allow writing efficient wrappers and allocating less memory.</li>
  <li>We want tuples, named tuples and named arguments.</li>
</ul>

But the thing we want most right now is to have the compiler written in Crystal. Once
we do this, we won't need Ruby anymore. We won't need to maintain two implementations
of the compiler. Compilation times will be reduced drmatically (we hope!).

And also, it's very likely that the language will grow a lot because
of this, and we will have learned a lot of what it feels like to program in Crystal and what
needs to be improved (debugging and profiling come to our minds). Dog-fooding, they call it :-)
