---
title: "Top 5 Reasons for Ruby-ists to Use Crystal"
author: marksiemers
description: "There are so many reasons for Rubysts to give Crystal a try - in this blogpost, Mark Siemers shares his top 5"
---

> _This is a guest post by [Mark Siemers](https://www.linkedin.com/in/marksiemers/), who kindly volunteered to suggest a series of Crystal blog posts. Expect more to come, or - even better - [contact us](http://twitter.com/intent/tweet?text=@CrystalLanguage%20I%20want%20to%20write%20about...) about writing your own post._

## 1. Extremely low learning curve

Think of some languages that have become popular in the last 5-10 years. What comes to mind? Elixir, Go, Rust perhaps? They all have performance advantages over Ruby but are more difficult to learn and master.

What if you could get the performance gain with a much easier learning curve?

How easy? Let's take a look at some code.

**Q:** Which of the following modules are written in Ruby? Which in Crystal?

<div class="code_section">
{% highlight ruby %}
module Year
  def self.leap?(year)
    year % 400 == 0 || (year % 100 != 0 && year % 4 == 0)
  end
end
{% endhighlight %}
</div>

<div class="code_section">
{% highlight ruby %}
module Hamming
  def self.distance(a,b)
    a.chars.zip(b.chars).count{|first, second| first != second }
  end
end
{% endhighlight %}
</div>

**A:** Trick question - it's both. The modules above will work in [Ruby](https://repl.it/@marksiemers1/HammingLeapYear) or [Crystal](https://play.crystal-lang.org/#/r/3ayq). How cool is that?

See more examples of code similarities [here](https://github.com/marksiemers/ruby-to-crystal).

This doesn't mean that all Ruby code will work in Crystal (and vice-versa), but you can do an awful lot with Crystal immediately and be productive on day one, even minute one.

How does Crystal (a strongly-typed & compiled language) act like Ruby (a dynamic & duck-typed language)? Crystal’s compiler uses a combination of two powerful techniques: [type inference](https://crystal-lang.org/reference/syntax_and_semantics/type_inference.html) and [union types](https://crystal-lang.org/reference/syntax_and_semantics/union_types.html). This allows the compiler to read your ruby-like code and figure out (infer) the correct types to use.

Beyond the similarities, Crystal offers some core advantages over Ruby. Advantages like...

## 2. Compile time checks & method overloading

Does it feel hacky when you write `is_a?` or `respond_to?` to make sure your code doesn't break in Ruby? Do you ever worry about all the places you did NOT put in those checks? Are those all bugs waiting to happen?

Crystal is a compiled language and checks all your method inputs and outputs at compile time. If any types don't line-up, they will be caught before runtime.

Let's revisit the `Year::leap?` example from above. In Ruby, what happens when the input isn't an integer?

<div class="code_section">
{% highlight ruby %}
Year.leap?("2016") #=> false
Year.leap?(Date.new(2016, 1, 1)) #=> undefined method `%' for #<Date: 2016-01-01 ... >
{% endhighlight %}
</div>

For a `String` we get the wrong answer, for a `Date` we get a runtime exception. Fixing things in Ruby would require at least one `is_a?` statement:

<div class="code_section">
{% highlight ruby %}
module Year
  def self.leap?(input)
    if input.is_a? Integer
      input % 400 == 0 || (input % 100 != 0 && input % 4 == 0)
    elsif input.is_a? Date
      input.leap?
    else
      raise ArgumentError.new("must pass an Integer or Date.")
    end
  end
end
{% endhighlight %}
</div>

Does [that method](https://repl.it/@marksiemers1/LeapYearOverloads) look good to you? We still have a chance at a runtime exception, just with a more helpful error message.

In Crystal, we have the option of explicitly typing our inputs (and outputs). We can change the method signature to `self.leap?(year : Int)` and we are guaranteed to have an integer as input.

We get helpful messages __at compile time__, rather than runtime:
<div class="code_section">
{% highlight ruby %}
Year.leap?("2016")
Error in line 10: no overload matches 'Year.leap?' with type String
Overloads are:
 - Year.leap?(year : Int)
{% endhighlight %}
</div>

If we want to add support for `Time` (think `DateTime` in Ruby) in our module, we can overload `Year::leap?`:

<div class="code_section">
{% highlight ruby %}
module Year
  def self.leap?(year : Int)
    year % 400 == 0 || (year % 100 != 0 && year % 4 == 0)
  end

  def self.leap?(time : Time)
    self.leap?(time.year)
  end
end
{% endhighlight %}
</div>

Like Ruby, method overloading allows flexibility with inputs but without the guesswork of duck-typing. Compile time checks prevent type mismatch errors from making it to production.

Speaking of production, how about...

## 3. Blazing fast performance

Another advantage of compilation is speed and optimization. When comparing the performance of Ruby to Crystal, often, it can be stated in orders of magnitude rather than percentages.

In one example, [summing random numbers in crystal](https://github.com/marksiemers/ruby-to-crystal/blob/master/src/enumerables/reduce_bench.cr) can be __10 orders of magnitude faster__ than Ruby (~ 37 million percent faster). This is due to compiler optimizations and the ability to use primitive data types in Crystal. This does come with the risk of integer overflow for large numbers ([See Ary's explanation](https://crystal-lang.org/2016/07/15/fibonacci-benchmark.html)).

Crystal's built-in HTTP server has been able to handle over [2 million requests per second in benchmark testing](https://www.techempower.com/benchmarks/previews/round15/#section=data-r15&hw=ph&test=plaintext&l=zdk8an&c=3). And many of the web frameworks are consistently delivering sub-millisecond response times for web applications.

Which brings us to the next point...

## 4. The web framework you want is already here

Love the completeness of Rails (or even Elixir’s Phoenix)? You'll feel right at home with the [Amber](https://amberframework.org/) framework.

Is the simplicity and easy customization of Sinatra more your thing? You'll find that simplicity with [Kemal](http://kemalcr.com/).

Do you want a full-stack framework that leverages compile time checks for strong params, HTTP verbs, and database queries? It's your [Lucky](https://luckyframework.org) day.

During January, each of these web frameworks will be highlighted in their own dedicated post. Check back with the Crystal blog to find out more.

## 5. Crystal is written in Crystal! It’s easy to understand and contribute to the language

Have you ever read Ruby’s source code? Tried to figure out how some `Enumerable` methods work?

[Ruby’s Implementation of `Enumerable#all?`](https://github.com/ruby/ruby/blob/v2_5_0/enum.c#L1215)

<div class="code_section">
{% highlight c %}
static VALUE
enum_all(int argc, VALUE *argv, VALUE obj)
{
    struct MEMO *memo = MEMO_ENUM_NEW(Qtrue);
    rb_block_call(obj, id_each, 0, 0, ENUMFUNC(all), (VALUE)memo);
    return memo->v1;
}
{% endhighlight %}
</div>

How long does it take to figure out what that code is doing? If you've never worked with C code, probably a really long time.

Compare that to [Crystal's implementation of `Enumerable#all?`](https://github.com/crystal-lang/crystal/blob/v0.24.1/src/enumerable.cr#L46)

<div class="code_section">
{% highlight ruby %}
def all?
  each { |e| return false unless yield e }
  true
end
{% endhighlight %}
</div>

How long did that take to figure out? If you know Ruby or Crystal, probably a matter of seconds.

With this in mind, consider that __98.4% of Crystal is written in Crystal__ and only 0.3% is written in C++.

Ruby is written 30.6% in C and 64.8% in Ruby.

In fact, only one file in crystal is written in C++, so as long as your aren’t changing [LLVM extensions](https://github.com/crystal-lang/crystal/blob/v0.24.1/src/llvm/ext/llvm_ext.cc) whatever you’re looking for in the crystal language is virtually guaranteed to be written in crystal.

Reading, understanding, and contributing to Crystal is easier than just about any language you can find.

## Where to start?

If you’re looking to try out the Crystal programming language, here are some good resources to get started:

- [Crystal Play](https://play.crystal-lang.org/#/cr) - an online REPL-like tool for Crystal
- [Install Crystal](/install)
- [Crystal for Rubyists](http://www.crystalforrubyists.com/)
- [Crystal Exercisms](http://exercism.io/languages/crystal/about)
- [Create your own HTTP Server in minutes](https://crystal-lang.org/reference/getting_started/http_server.html)
