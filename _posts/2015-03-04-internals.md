---
title: Internals
summary: Memory representation
thumbnail: 0x
author: asterite
---

Let's talk about what Crystal does with your code: how it represents types in memory,
how it does method lookup at runtime, how it does method dispatch, etc. When using a programming language it's always
useful to know this in order to structure our code in the most efficient way, and to precisely understand what our code
will be transformed to.

## How types are represented in memory

For talking about type representations we will use C and LLVM IR code, so be sure to check [the reference](http://llvm.org/docs/LangRef.html#type-system).

Crystal has built-in types, user defined types and unions.

### Built-in types

These are Nil, Bool, Char and the various number types (Int32, Float64, etc.), Symbol, Pointer, Tuple, StaticArray, Enum, Proc and Class.

Let's check how a Bool is represented. For this, let's write this small program:

```ruby
# test.cr
x = true
```

To see the generated LLVM we can use this command:

<pre class="code">
crystal build test.cr --emit llvm-ir --prelude=empty
</pre>

The `--emit llvm-ir` flag tells the compiler to dump the resulting LLVM IR code to a test.ll file.
The `--prelude=empty` tells the compiler to not use
the [default prelude file](https://github.com/crystal-lang/crystal/blob/master/src/prelude.cr), which, for example,
[initializes the GC](https://github.com/crystal-lang/crystal/blob/965d6959163717d72cd3703159d60004ebf7f266/src/main.cr#L42).

In this way we can get a very simple and clean LLVM IR code file with just the code we write:

```llvm
; ModuleID = 'main_module'

%String = type { i32, i32, i32, i8 }

@symbol_table = global [0 x %String*] zeroinitializer

define i1 @__crystal_main(i32 %argc, i8** %argv) {
alloca:
  %x = alloca i1
  br label %entry

entry:                                            ; preds = %alloca
  store i1 true, i1* %x
  ret i1 true
}

declare i32 @printf(i8*, ...)

define i32 @main(i32 %argc, i8** %argv) {
entry:
  %0 = call i1 @__crystal_main(i32 %argc, i8** %argv)
  ret i32 0
}
```

The gist is in `__crystal_main`: we can see the compiler allocates an `i1` in the stack for `x` and then stores `true` in it.
That is, the compiler represents a Bool as a single bit, which is pretty efficient.

Let's do the same for an int:

```ruby
x = 1
```

For `x` this time we will get:

```llvm
%x = alloca i32
```

In LLVM, and i32 is an int represented with 32 bits, which, again, is pretty efficient and what we would expect the representation
of `Int32` to be.

That is, even though Crystal is object-oriented and an Int32 behaves like an object (it has methods), its internal representation
is as efficient as possible.

### Symbol

Let's see Symbol now:

```ruby
x = :one
y = :two
```

Let's see the full LLVM IR code this time:

```llvm
; ModuleID = 'main_module'
target datalayout = "e-m:o-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-apple-darwin14.1.0"

%String = type { i32, i32, i32, i8 }

@one = private constant { i32, i32, i32, [4 x i8] } { i32 1, i32 3, i32 3, [4 x i8] c"one\00" }
@two = private constant { i32, i32, i32, [4 x i8] } { i32 1, i32 3, i32 3, [4 x i8] c"two\00" }
@symbol_table = global [2 x %String*] [%String* bitcast ({ i32, i32, i32, [4 x i8] }* @one to %String*), %String* bitcast ({ i32, i32, i32, [4 x i8] }* @two to %String*)]

define internal i32 @__crystal_main(i32 %argc, i8** %argv) {
alloca:
  %x = alloca i32
  %y = alloca i32
  br label %entry

entry:                                            ; preds = %alloca
  store i32 0, i32* %x
  store i32 1, i32* %y
  ret i32 1
}

declare i32 @printf(i8*, ...)

define i32 @main(i32 %argc, i8** %argv) {
entry:
  %0 = call i32 @__crystal_main(i32 %argc, i8** %argv)
  ret i32 0
}
```

Three things are important here. First, we can see that a Symbol is represented as `i32`, that is, with four bytes. Second,
we can see `x` is assigned a value of 0 and `y` is assigned a value of 1. Third, we can see some constants at the top:
`hello`, `bye` and `symbol_table`.

Basically, a Symbol in Crystal is just a name assigned to a unique number. A Symbol can't be created dynamically
(there's no `String#to_sym`) and the only way to create them is with their literal value, so the compiler can know
all the symbols used across the program. The compiler assigns a number to each of them, starting from zero, and it also
builds a table that map their number to a string, to be able to implement `Symbol#to_s` in a very efficient way.
This makes symbols very attractive to use for small groups of constants, because it's like using magic numbers but with names instead.

### Pointer

A Pointer is a generic type that represents a typed pointer to some memory location. For example:

```ruby
x = Pointer(Int32).malloc(1_u64)
x.value = 1
x.value #=> 1
```

If you look at the generated LLVM IR code you will see a bunch of code. First, `x` is represented like this:

```llvm
%x = alloca i32*
```

Again, this is just a pointer to an int32, as it should be. Next you will see a call to `malloc` (will ask memory from the GC
using the regular prelude) and `memset` to clear the memory, and then some instructions to assign 1 in that memory address.
This is not very important for the subject of this blog post, so we skip it, but it's important to know that generated code
is very similar to what would be generated in C.

### Tuple

A Tuple is a fixed-size, immutable sequence of values, where the types at each position are known at compile time.

```ruby
x = {1, true}
```

Pieces of LLVM IR code for the above are:

```llvm
%"{Int32, Bool}" = type { i32, i1 }
...
%x = alloca %"{Int32, Bool}"
```

As we can see, a tuple is represented as an [LLVM structure](http://llvm.org/docs/LangRef.html#structure-type), which just
packs values sequentially. This representation of tuples allows us, for example, to decompose an Int32 into its bytes,
in this way:

```ruby
x = 1234
ptr = pointerof(x) as {UInt8, UInt8, UInt8, UInt8}*
puts ptr.value #=> {21, 205, 91, 7}
```

### StaticArray

A StaticArray is a fixed-size, mutable sequence of values of a same type, allocated on the stack and passed by value.
The prelude includes safe ways to create them, but since we are using a bare-bones prelude an unsafe (will be initialized
to data containing garbage) way to create them is this:

```ruby
x = uninitialized Int32[8]
```

Its LLVM representation:

```llvm
%x = alloca [8 x i32]
```

We won't talk much more about this type because it's not used that much, mostly for IO buffers and such: Array is the
recommended type for all other operations.

### Enum

Here's an enum:

```ruby
enum Color
  Red
  Green
  Blue
end

x = Color::Green
```

An enum is, in a way, similar to Symbol: numbers associated to names so we can use names in our code instead of
magic numbers. As expected, an enum is represented as an i32, that is four bytes, unless specified otherwise
in its declaration:

```ruby
enum Color : UInt8
  Red
  Green
  Blue
end
```

The nice thing about enums is that you can print them and you get their name, not their value:

```ruby
puts Color::Green #=> Green
```

This is done in a different way than with Symbol, [using compile-time reflection and macros](https://github.com/crystal-lang/crystal/blob/965d6959163717d72cd3703159d60004ebf7f266/src/enum.cr#L4).
But, basically, an enum's `to_s` method is generated only when needed. But it's nice that an enum is memory and speed efficient
and also comfortable to use and to debug with (like, you get names instead of numbers when printing them).

### Proc

A Proc is a function pointer with an optional closure data information. For example:

```ruby
f = ->(x : Int32) { x + 1 }
```

This is a function pointer that receives an Int32 and returns an Int32. Since it doesn't capture any local variables
it's not a closure. But the compiler still represents it like this:

```llvm
%"->" = type { i8*, i8* }
```

That is a pair of pointers: one containing the pointer to the real function, another one containing a pointer to the
closured data.

The LLVM IR code for the above is:

```llvm
; ModuleID = 'main_module'

%String = type { i32, i32, i32, i8 }
%"->" = type { i8*, i8* }

@symbol_table = global [0 x %String*] zeroinitializer

define %"->" @__crystal_main(i32 %argc, i8** %argv) {
alloca:
  %f = alloca %"->"
  %0 = alloca %"->"
  br label %entry

entry:                                            ; preds = %alloca
  %1 = getelementptr inbounds %"->"* %0, i32 0, i32 0
  store i8* bitcast (i32 (i32)* @"~fun_literal_1" to i8*), i8** %1
  %2 = getelementptr inbounds %"->"* %0, i32 0, i32 1
  store i8* null, i8** %2
  %3 = load %"->"* %0
  store %"->" %3, %"->"* %f
  ret %"->" %3
}

declare i32 @printf(i8*, ...)

define i32 @main(i32 %argc, i8** %argv) {
entry:
  %0 = call %"->" @__crystal_main(i32 %argc, i8** %argv)
  ret i32 0
}

define internal i32 @"~fun_literal_1"(i32 %x) {
entry:
  %0 = add i32 %x, 1
  ret i32 %0
}
```

A bit harder to digest than the above examples, but it's basically assining a pointer to `~fun_literal_1` in the first
position and `null` in the second. If our Proc captures a local variable:

```ruby
a = 1
f = ->(x : Int32) { x + a }
```

The LLVM IR code changes:

```llvm
; ModuleID = 'main_module'

%String = type { i32, i32, i32, i8 }
%"->" = type { i8*, i8* }
%closure = type { i32 }

@symbol_table = global [0 x %String*] zeroinitializer

define %"->" @__crystal_main(i32 %argc, i8** %argv) {
alloca:
  %f = alloca %"->"
  %0 = alloca %"->"
  br label %entry

entry:                                            ; preds = %alloca
  %malloccall = tail call i8* @malloc(i32 ptrtoint (i32* getelementptr (i32* null, i32 1) to i32))
  %1 = bitcast i8* %malloccall to %closure*
  %a = getelementptr inbounds %closure* %1, i32 0, i32 0
  store i32 1, i32* %a
  %2 = bitcast %closure* %1 to i8*
  %3 = getelementptr inbounds %"->"* %0, i32 0, i32 0
  store i8* bitcast (i32 (i8*, i32)* @"~fun_literal_1" to i8*), i8** %3
  %4 = getelementptr inbounds %"->"* %0, i32 0, i32 1
  store i8* %2, i8** %4
  %5 = load %"->"* %0
  store %"->" %5, %"->"* %f
  ret %"->" %5
}

declare i32 @printf(i8*, ...)

declare noalias i8* @malloc(i32)

define i32 @main(i32 %argc, i8** %argv) {
entry:
  %0 = call %"->" @__crystal_main(i32 %argc, i8** %argv)
  ret i32 0
}

define internal i32 @"~fun_literal_1"(i8*, i32 %x) {
entry:
  %1 = bitcast i8* %0 to %closure*
  %a = getelementptr inbounds %closure* %1, i32 0, i32 0
  %2 = bitcast i8* %0 to %closure*
  %3 = load i32* %a
  %4 = add i32 %x, %3
  ret i32 %4
}
```

This is even harder to digest, but basically some memory is asked that will contain the value of the variable `a`, and
the Proc receives it and uses it. In this case the memory is asked with `malloc`, but with the regular prelude the memory
will be allocated by the GC and released when no longer needed.

### Class

Classes are objects too:

```ruby
x = Int32
```

Not surprisingly, a class is represented as an Int32:

```ruby
%x = alloca i32
...
store i32 45, i32* %x
```

Because classes can't be created at runtime, and the compiler knows all classes, it assigns a type id to them
and that way it can identify them.

## User-defined types

Users can define classes and structs. The difference is that newing a class allocates it on the heap, and a pointer
to that data is passed across variables and methods, while newing a struct allocates that memory on the stack and the whole
struct's value is passed, copied, across variables and methods.

Let's try it:

```ruby
class Point
  def initialize(@x, @y)
  end
end

x = Point.new(1, 2)
```

The LLVM IR code contains:

```llvm
%Point = type { i32, i32, i32 }
...
%x = alloca %Point*
```

Mmm... wait! A Point has just two instance variables, `@x` and `@y`, both of type Int32, so why there's another `i32`
there? Well, it turns out Crystal adds an Int32 to store a type id associated with the class. This doesn't make much sense
right now, but when we'll talk about how unions are represented it will make more sense.

Let's see the same for a struct:

```ruby
struct Point
  def initialize(@x, @y)
  end
end

x = Point.new(1, 2)
```

The LLVM IR code contains:

```llvm
%Point = type { i32, i32 }
...
%x = alloca %Point
```

In this case a struct doesn't contain the extra Int32 field for the type id.

Now comes the fun part: unions!

## Unions

Crystal supports unions of arbitrary types. For example you can have a variable that has either an Int32 or a Bool:

```ruby
if 1 == 2
  x = 3
else
  x = false
end
```

At the end of the `if` the variable `x` will either be `3` or `false`, which makes it type an Int32 or a Bool.
The Crystal way to talk about a union is using a pipe, like this: `Int32 | Bool`. In the LLVM IR code we can find:

```llvm
%"(Int32 | Bool)" = type { i32, [1 x i64] }
...
%x = alloca %"(Int32 | Bool)"
```

We can see that the representation of this particular union is an LLVM structure containing two fields. The first
one will contain the type id of the value. The second one is the value itself, which is a bit array as large as
the largest type in that union (due to some alignment concerns, the size is extended to 64 bits boundaries in 64 bit
architectures). In C it would be:

```c
struct Int32OrBool {
  int type_id;
  union {
    int int_value;
    bool bool_value;
  };
}
```

The first field, the type id, will be used by the compiler when you invoke a method on `x`.

So, it would seem that here ends the story about how union types are represented. However, there are some unions
that are very common: nilable types.

We didn't talk about Nil previously, but since it can only contain a single value, and you can't use `void` for a value,
its represented as i1:

```ruby
x = nil # %x = alloca i1
```

Let's make now a union of nil and a class:

```ruby
if 1 == 2
  x = nil
else
  x = Point.new(1, 2)
end
```

If we check the LLVM IR code we will see this for x:

```llvm
%x = alloca %Point*
```

So a union of `Point | Nil`, where Point is a class, is represented in the same was as the Point class. How can
we tell if x is Nil or Point? Easy: a null pointer means it's Nil, a non-null pointer means it's a Point.

In fact, all unions that only involve classes and/or nil are always represented as a single pointer. If it's
a null pointer, it's Nil. Otherwise, if the union contains many possible classes, we can know the type with the
first member of the value, an Int32, remember? Having all of these unions be represented as pointers makes the
code much more efficient, as pointers fit in registers and occupy very little memory.

However, a union of Nil and a struct will always be represented as a tagged union, like the `Int32 | Bool` case.
But these unions are much less common.

Now that we understand how types are represented and how, at runtime, we can know what type is contained in a
union, let's talk about method dispatch.

## Method dispatch

Although Crystal is object-oriented, method lookup and dispatch work very different than other object-oriented
languages. For example, there are no virtual tables and no metadata stored for types (except that type id field we
talked before). We try to minimize the runtime data needed for a program to work, and also maximize its speed of
execution, sometimes sacrificing the resulting binary size (which doesn't grow a lot, either). For example, let's
consider this class hierarchy:

```ruby
module Moo
  def foo
    1
  end
end

class Foo
  def foo
    2
  end
end

class Bar < Foo
  include Moo
end

class Baz < Bar
end

Baz.new.foo #=> 1
```

Wow, a big class hierarchy and even an included module, and two definitions for `foo`. By looking at the code,
can you know which `foo` method will get invoked in this case?

...

Well, it's `Moo#foo`, right? Yes, indeed. Well, it turns out the compiler knows this too, and if you take a look
at the generated code you will see something like this:

```llvm
; Create a Bar
%0 = call %Baz* @"*Baz::new:Baz"()
; Invoke Moo#foo: no method lookup
%1 = call i32 @"*Baz@Moo#foo<Baz>:Int32"(%Baz* %0)

...

define internal i32 @"*Baz@Moo#foo<Baz>:Int32"(%Baz* %self) {
entry:
  ret i32 1
}
```

What happens if we create an instance of Bar and we invoke `foo` on it too:

```ruby
Bar.new.foo
Baz.new.foo
```

Now the LLVM IR code contains this:

```llvm
%0 = call %Bar* @"*Bar::new:Bar"()
%1 = call i32 @"*Bar@Moo#foo<Bar>:Int32"(%Bar* %0)
%2 = call %Baz* @"*Baz::new:Baz"()
%3 = call i32 @"*Baz@Moo#foo<Baz>:Int32"(%Baz* %2)
...
define internal i32 @"*Bar@Moo#foo<Bar>:Int32"(%Bar* %self) {
entry:
  ret i32 1
}

define internal i32 @"*Baz@Moo#foo<Baz>:Int32"(%Baz* %self) {
entry:
  ret i32 1
}
```

Oops, isn't there a duplicated definition of `foo` there? Well, yes. You can think as if the compiler
copied foo's definition into each class, and so there will be, indeed, many copies of the same method.
But this doesn't matter much: most methods are not big, and method call speed is much more important. Furthermore,
small methods get inlined anyway in an optimized build, and there's even an LLVM transformation pass to
detect duplicated functions and merge them.

Of course, the story changes a bit if `Moo#foo` invokes an instance method or uses an instance variable. In this
case the "duplicated" methods will actually be different, again, as if we copied each method definition
into each type that finally contains it. This makes method call as efficient as possible, at the cost
of (possibly) increasing executable size. But end users are usually more concerned about speed than
executable size.

All of the above is possible because the compiler knows the exact type of `Bar.new`. What happens
if the compiler doesn't know this? Let's start with a simple union where types are not classes
in the same hierarchy:

```ruby
class Foo
  def foo
    1
  end
end

class Bar
  def foo
    1
  end
end

if 1 == 2
  obj = Foo.new
else
  obj = Bar.new
end
obj.foo
```

This time the compiler will generate code that more or less does this: before invoking `foo` on `obj`,
check what type is `obj`. This can be known by loading the first field (the type id) of the pointer
that represents the object. Then based on this we invoke one method or another. The decision for this
is just one memory load and a comparison: very efficient. For a bigger union it would still be one memory
load or just reading the type id field of a union, and then many comparisons. But... wouldn't a lookup
table be faster?

Well, it turns out LLVM is pretty smart, and when it detects many comparisons it can sometimes build a
lookup table for us. For this to work better, the numbers inside the lookup table must be close to each
other (imagine a lookup table for the values 1 and 1000000, it would take a lot of space so LLVM would
decide to do comparisons in that case). Luckily, we assign type ids in a way that helps LLVM
achieve this.

When we say `big unions` chances are that that union contains classes of the same hierarchy: you usually
build a class hierarchy to make all types follow a certain rule, respond to a similar set of methods.
Although you can do this without a class hierarchy, they are a very common way of structuring code.

Consider this class hierarchy:

```ruby
class Foo; end
class Bar < Foo; end
class Baz < Bar; end
class Qux < Bar; end
```

Considering these types only, the compiler assigns type ids in a post-order way: first Baz gets assigned
1, then Qux gets assigned 2, then Bar gets assigned 3, and finally Foo gets assigned 4. Also, the compiler
tracks the range of type ids of a type's subtypes, including itself, so for Bar it also assigns the
range 1-3, and for Foo it assigns the range 1-4.

Now, consider this:

```ruby
class Foo
  def foo
    1
  end
end

class Bar < Foo
  def foo
    2
  end
end

class Baz < Bar; end
class Qux < Bar; end

obj = # ... a union of the above types
obj.foo
```

First, the compiler will type `obj` as `Foo+`, meaning it can be Foo or one of its sublcasses (read
more about this [here](http://crystal-lang.org/docs/syntax_and_semantics/virtual_and_abstract_types.html)).
In this case, there will be only two different method instantiations: one for `Foo+` and one for `Bar+`, since
Baz and Qux don't redefine that method. To know which one we need to call, we load the type id. Then, instead
of having to say "if the type id is that of Bar, or Baz or Qux, call Bar#foo, otherwise call Foo#foo`, we
can simply check if the type id is in the range previously assigned to Bar (1-3): just two comparisons.

This range check also works with `is_a?`. When you do `obj.is_a?(Foo)`, and maybe `obj` is an Int32 or, Foo,
or one of its subclasses, we can solve this with at most two comparisons.

Finally, an interesting aspect of Crystal is that method dispatch happens based on possibly many types:

```ruby
def foo(x : Int32, y : Char)
end

def foo(x : Char, y : Int32)
end

def foo(x, y)
end

foo 1, 'a'
```

And this also works if the type of all arguments is not known at compile time. But... this blog post is getting a bit
long and complex by now: there are many more micro-optimizations that we apply to your
code to make it as efficient as possible. So don't be afraid to use Crystal to its full potential :-)
