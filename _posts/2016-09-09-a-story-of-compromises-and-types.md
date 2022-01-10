---
title: A story of compromises and types
summary:
thumbnail: 👻
author: bcardiff
---

Let's play with an immutable Queue type. We want to:

1. Create an empty queue
1. Push things into a queue and get a new queue with the added element
1. Pop the next element of the queue and also get the rest of the queue.

So something like this:

```ruby
q = build_queue  # q = {}
new_q = q.push 2 # q = {2}
e, old_q = new_q.pop # e = 2, q = {}
```

If we jump into creating a Queue class we will get the following skeleton:

```ruby
class Queue
  # returns a new queue with `e` at the beginning
  def push(e)
    # ...
  end

  # returns the next element and a queue
  # with the remaining elements
  # fails if queue is empty
  def pop
    raise EmptyQueueRuntimeError.new if empty?
    # ...
  end
end
```

This could work. However, there are some kinds of programs that will compile, but will *always* fail to run:

```ruby
q = Queue.new
e, q = q.pop # => EmptyQueueRuntimeError :-(
```


Going in a a similar direction of the [NullPointerException](/2013/07/13/null-pointer-exception.html), we could try to split the queue values that will help us move from this `EmptyQueueRuntimeError` to a compile error. For that, we need to differentiate the `EmptyQueue` from the non-empty Queues.

```ruby
class EmptyQueue
  # Always return a Queue
  def push(e)
  end
end

class Queue
  # Always return a Queue
  def push(e)
    # ...
  end

  # Return Queue or EmptyQueue
  def pop
  end
end

q = EmptyQueue.new
q.pop # => Compile Error :-) EmptyQueue does not have EmptyQueue#pop
```

But is it really useful?

```ruby
q0 = EmptyQueue.new   # q0 = {}
q1 = q0.push 1        # q1 = {1}
q2 = q1.push 2        # q2 = {2, 1}
e, q3 = q2.pop        # q3 = {1}, e = 2
e, q4 = q3.pop        # => Compile Error :-( , but *we* know q3 is not empty...
```

The compile error is because `typeof(q3) :: EmptyQueue | Queue`.

The fact that popping from a nonempty queue *may* lead to an empty queue stands between us and what we want to do. A “*may* lead” is translated to the return type since it is one of the possible results in runtime.

We could try to do something _crazy_. What if `Queue` contains the amount of elements in its type. We know that if you:

1. Push an element to a `Queue(N)`, you will get a `Queue(N+1)`
1. Pop from a `Queue(1)`, you will get an `EmptyQueue`
1. Pop from a `Queue(N)` with `N > 1`, you wil get a `Queue(N-1)`

It seems reasonable (and a bit crazy).

In a static typed language the compiler will use the types of the expressions. It won’t, since it can’t, rely on their actual values because those will only appear during execution. Programmers can _deduce_ a certain behaviour of a program that holds for all possible executions, but this analysis goes beyond just the types of the expressions. This is something hard to realise if you are only used to dynamic languages. What we are trying to do is to take a bit more of information from the queues and add it to the `Queue(N)` type, so that the compiler will be able to use the information of the types to _decide_ if the program does actually makes sense and hence compiles.

For this we will need:

* A way to declare overloads `Queue(1)` and `Queue(N)` (with `N > 1`)
* Be able to use Math operators in types: given `N`, return `Queue(N+1)`.
  * And teach the type inference how to deduce these things so we don’t need to always write them.

Even if we added this, it’s a risky business: Let's imagine we want a `#filter` operation that will remove from the queue all elements that are equal to a certain value. What will be the return type of `Queue(N)#filter(e)`?

Potentially `Queue(N) | Queue(N-1) | Queue(N-2) | .... | Queue(1) | EmptyQueue`.
Or even `Queue(N-R)` where `R=#count of e in self`.
See? _scary_ 👻.

Types are powerful stuff.

There is a lot of theory behind type systems. This story grazes [Dependent types system](https://en.wikipedia.org/wiki/Dependent_type).

Types group values and serve as a basis for static analysis. Analysis that won’t depend on the actual values.

If the type goes into too much detail, then it will be a pain to use.
It the type ignores lots of details, then we will get lots of exceptions in runtime.

This situation has been coming up all the time since we began designing Crystal's type system and API. We aim to define a useful type system that will help programmers catch runtime exceptions, but we want it to be usable and easy-going. That is why:

* `Nil` is not a value of every type `T`. You need to use unions of `T | Nil` (or `T?`)
* `Array(T)` is able to hold only one type (although it can be a union), but we don’t know which indices are valid in compile time.
* `Tuples(*T)` are not as flexible as an `Array(T)` but given a literal we can know if it is a valid index and which type it corresponds to in compile time.
* `Array(T)`/`Tuple(*T)` relationship is analogous to `Hash(K,V)`/`NamedTuple(**T)`.
* `Array(T?)#compact` returns an `Array(T)`

Although the `Queue` story didn’t end up so well, it did end up well for all of the above types,
allowing us to have a happy time while crystalling. Success!







