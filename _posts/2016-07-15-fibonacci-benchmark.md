---
title: Fibonacci benchmark
summary: "Ruby vs. Crystal"
thumbnail: f
author: asterite
---

When trying out Crystal it's tempting, and very fun, to write small benchmarks to see
how the language's performance compares to other languages. Because of its syntax,
comparing with Ruby is usually the simplest thing to do. Many times we can even
use the same code.

Let's compare the fibonacci function:

<div class="code_section">{% highlight ruby %}
# fib.cr
def fib(n)
  if n <= 1
    1
  else
    fib(n - 1) + fib(n - 2)
  end
end

time = Time.now
puts fib(42)
puts Time.now - time
{% endhighlight ruby %}</div>

Let's compare the times.

<pre>
$ ruby fib.cr
433494437
37.105234
$ crystal fib.cr --release
433494437
00:00:00.9999380
</pre>

As can be seen, Crystal is giving us a huge increase in performance. Nice!

However, there's a fundamental problem in the above benchmark:
we aren't comparing the same function, the same algorithm.

To see that this is true, let's try increasing the number 42 to 46 and run
the programs again:

<pre>
$ ruby fib.cr
2971215073
260.206918
$ crystal fib.cr --release
-1323752223
00:00:06.8042220
</pre>

What did just happen?

It turns out Crystal has several integer types that map to a computer's integers:
Int8 for signed numbers represented with 8 bits, Int32 for signed numbers represented
with 32 bits, UInt64 for unsigned numbers represented with 64 bits and so on. The
default type of an integer literal in Crystal is Int32, so its maximum value is
`(2 ** 31) - 1 == 2147483647`. Because `2971215073` is bigger than this, the operation
overflows and gives a negative result.

Ruby, on the other hand, has two integer types: Fixnum and Bignum (although [in Ruby
2.4 they will be unified](https://bugs.ruby-lang.org/issues/12005) in a single Integer class).
Ruby tries to represent integers with 64 bits if the are "small"
([less than 4611686018427387903](http://patshaughnessy.net/2014/1/9/how-big-is-a-bignum)),
trying not to allocate heap memory, and will use heap memory to represent integers larger than
that. When doing operations between integers, Ruby will make sure to create a Bignum in case
of overflow, to give a correct result.

Now we can understand why Ruby is slower: it has to do this overflow check on every operation,
preventing some optimizations. Crystal, on the other hand, can ask LLVM to optimize this code
very well, sometimes even letting LLVM compute the result at compile time. However, Crystal
might give incorrect results, while Ruby makes sure to always give the correct result.

In my opinion, Ruby's philosophy is, whenever there's a choice between correct behavior and
good performance, to favor correct behaviour. One can see this in this small example:

<pre>
$ irb
irb(main):001:0> a = []
=> []
irb(main):002:0> a << a
=> [[...]]
</pre>

Note that when printing an array, Ruby notices that it reached the same array it was printing,
so it printed `[...]` to show this. The program didn't hang up, recurisvely trying to print the
same array over and over. To implement this, Ruby has to remember that this Array is being printed,
probably putting it in a Hash of some sort, and when printing an object inside this Array a hash
lookup is performed.

The same happens when you inspect an object, and the object has a reference to itself:

<pre>
irb(main):001:0> class Foo
irb(main):002:1>   def initialize
irb(main):003:2>     @self = self
irb(main):004:2>   end
irb(main):005:1> end
=> :initialize
irb(main):006:0> Foo.new
=> #<Foo:0x007fc7429bbe30 @self=#<Foo:0x007fc7429bbe30 ...>>
</pre>

These subtleties aren't immediately visible in Ruby, but once you discover them they make
you have a profound respect for Matz and his team.

These choices have an impact on performance, though. If we'd like Crystal to give the correct
result to `fib`, like in Ruby, we would have to sacrifice some performance. However, Crystal
makes this decision because doing big numbers math, and checking overflows all the time,
affects every part of a program. For example, there's a CPU instruction to increment a number
by one, and Crystal can take advantage of it. Ruby probably can't, because it also needs
to check for overflow.

There is, however, a way to get the correct result in Crystal, and this is similar to other languages:
explicitly use big numbers. Let's do it:

<div class="code_section">{% highlight ruby %}
require "big"

def fib(n)
  if n <= 1
    BigInt.new(1)
  else
    fib(n - 1) + fib(n - 2)
  end
end

time = Time.now
puts fib(BigInt.new(42))
puts Time.now - time
{% endhighlight ruby %}</div>

Let's run it:

<pre>
$ crystal fib.cr --release
433494437
00:02:28.8212840
</pre>

Now we get the correct result, but note that this is about 4~5 times slower than Ruby.
Why?

I don't know the answer, but I have some guesses. Maybe Ruby's Bignum implementation is
more efficient than LibGMP, the library we are using for BigInt.
Maybe Ruby's GC is better than the GC we are currently using, which isn't precise.
Maybe Ruby has some specific optimizations for these scenarios. In any case, I feel
a profound respect for Ruby, again.

Can we improve the performance of `fib` to match that of Ruby? We can try. One simple
thing is to use an iterative method, instead of doing it recursively, to avoid
creating too many BigInt instances. Let's try:

<div class="code_section">{% highlight ruby %}
require "big"

def fib(n)
  a = BigInt.new(1)
  b = BigInt.new(1)
  n.times do
    a += b
    a, b = b, a
  end
  a
end

time = Time.now
puts fib(42)
puts Time.now - time
{% endhighlight ruby %}</div>

Running it:

<pre>
$ crystal fib.cr --release
433494437
00:00:00.0006460
</pre>

Much better! And way faster than Ruby. But, of course, we are cheating because Ruby still
uses the old, slow algorithm. So to be fair, we must update our Ruby implementation:

<div class="code_section">{% highlight ruby %}
def fib(n)
  a = 1
  b = 1
  n.times do
    a += b
    a, b = b, a
  end
  a
end

time = Time.now
puts fib(42)
puts Time.now - time
{% endhighlight ruby %}</div>

Running it:

<pre>
$ ruby fib.rb
433494437
3.6e-05
</pre>

Ruby is still faster than Crystal in this case, maybe because no Bignum was created in this
case.

Is there something else we can do?

Yes. Crystal's `BigInt` is currently immutable, but maybe it could be changed to be mutable,
and be used like this for scenarios where performance of these operations is super important,
or a bottleneck in the program. Let's reopen Crystal's BigInt and make some changes:

<div class="code_section">{% highlight ruby %}
require "big"

struct BigInt
  def add!(other : BigInt) : BigInt
    LibGMP.add(self, self, other)
    self
  end
end

def fib(n)
  a = BigInt.new(1)
  b = BigInt.new(1)
  n.times do
    a.add!(b)
    a, b = b, a
  end
  a
end

time = Time.now
puts fib(42)
puts Time.now - time
{% endhighlight ruby %}</div>

Running it:

<pre>
$ crystal fib.cr --release
433494437
00:00:00.0006910
</pre>

Hmmm... it didn't change much. But if we try with a bigger number, say 300_000, these are the times:

<pre>
$ ruby fib.rb
# number ommited
1.880515
$ crystal fib.cr --release
# number ommited
00:00:00.7621470
</pre>

It seems that with big numbers, and avoiding creating multiple BigInt instance, Crystal performs
a bit better than Ruby in this case.

Can we make Ruby faster? I don't know. At least Ruby's API doesn't allow mutating a Bignum,
so at least now there's nothing that can be done. But since the performance is already quite
good, maybe there's no need to improve anything in the first place.

## Conclusion

There are several conclusions to this blog post.

First, Ruby is just awesome. It strives to give you correct results, and it does so with a reasonable
performance. <i>Chapeau!</i>

Second, be careful with benchmarks: make sure you are benchmarking the same algorithm, and, if possible,
try to explain why there's a possible difference in times (or memory usage) between languages, codes, frameworks, etc.

Third, Crystal lets you be very performant, but it requires more work from you, the programmer.
This is a difference from Ruby. However, Crystal tries to keep almost the same developer happiness
that Ruby gives you: it might make you feel sad or angry writing `BigInt.new(1)`, but this is
compensated with the happiness you get when you run your code and see it executes very fast.
