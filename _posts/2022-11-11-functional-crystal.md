---
title: Functional Crystal
summary: A tour on the functional aspects of Crystal
author: beta-ziliani
---

If someone posts a claim "_Crystal is a functional language_", they would be given a grim look. I mean, classes and inheritance are all over the place in the stdlib. Surely it's an object oriented language, right?

But it's not 2000 anymore, and no ones thinks in binary terms anymore, so why should we? If we make a careful read of modern programming languages, we'll find that neither functional languages are strictly functional, nor object oriented ones are strictly object oriented. Crystal is not an exception!

But why should you care? As it turns out, functional programming got fancy these years for several reasons, which can be simplified as:

>TIP
Functional programming helps write safe and modular code.

In this post, we will revisit what makes functional programming exciting, and how Crystal helps you write functional code.

# Immutability

A key aspects of functional programming is related to the idea that any change in the state of the program should be local. A way to describe this is with the following comparison, where `f` is any function or method, and `x` any value:

```cr
f(x) == f(x)
```

Sounds like this should hold, right? I mean, calling _the same function_ with _the same argument_ should return _the same value_.

<img src="/assets/blog/functional/fx-eq-fx-right.jpg" alt="Anakin showing Padme that f(x) might not be equal to f(x)" class="center"/>

Anakin could show Padme the following function that makes the comparison be false:

```cr
def f(x)
  Random.rand 100
end
```

Generating a random number is a _non-local effect_: the value `Random.rand` does not depend on `f`.

Now, there are several languages that consider themselves functional languages, but allow _non-local effects_. These languages are sometimes mentioned as _hybrid_, and an important part of this post is in making the case that Crystal is also a hybrid language. It definitively favors OOP, but it also allows important functional patterns.

# Values and references

And important aspect of immutability is to pass elements _by value_ instead of _by reference_. Consider the following code:

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

> Point
Changes in an instance of a class will **not** be local and affect the instance itself.

## Immutable types

As mentioned previously, there is a special type of object that is passed as value: instances of `struct`s. The following is a good example of how structs work:

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

Note what's happening here: the function `translate_x` alters the value of the `x` component, and this change works locally: the _new_ copy of the point has its value altered.
