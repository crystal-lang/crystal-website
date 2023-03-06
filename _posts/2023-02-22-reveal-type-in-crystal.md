---
title: "Reveal type in Crystal"
author: bcardiff
summary: "Porting reveal_type from Sorbet to Crystal."
---

Recently I came across [`reveal_type` from Sorbet](https://sorbet.org/docs/flow-sensitive#example) as a way to inspect the type of an expression, thanks [Brian Hicks](https://www.brianthicks.com/). I wondered if that can be ported to Crystal. You can jump to the [conclusions](#conclusions) section if you want to copy-paste the good-enough™️ solution in your project.

Inspecting the type of an expression is a reasonable question to ask. When the program compiles, the compiler knows the answer for sure.

Let’s start working with a relatively simple example grabbed from Sorbet’s documentation.

```crystal
def maybe(x, default)
  # what's x type here?
  if x
    x
  else
    default
  end
end

def sometimes_a_string
  rand > 0.5 ? "a string" : nil
end

maybe(sometimes_a_string, "a default value")
```

## Existing Solution: puts debug

Debugging the execution of a program using `printf`/`print`/`puts` is widely used. In Crystal we could write some variation of:


```crystal
puts "x = #{x.inspect} : #{x.class}"
#
# Output:
#
# x = "a string" : String
#
# or
#
# x = nil : Nil
```

That will show, when the program is executed, the actual value and type of `x`. But we don’t want to see the runtime type, we need the compile-time type. So a more accurate alternative would be

```crystal
puts "x = #{x.inspect} : #{typeof(x)}"
#
# Output:
#
# x = "a string" : (String | Nil)
#
# or
#
# x = nil : (String | Nil)
```

or

```crystal
pp! typeof(x)
#
# Output:
#
# typeof(x) # => (String | Nil)
```

## Existing Solution: context tool

About 8 years ago Crystal [gained some built-in tooling](/2015/09/05/tools/) and one of those tools would give us exactly the information we are looking for.

Assuming the previous `def maybe` is defined at the beginning of a  `program.cr` we could use the context tool as follows:


```console
% crystal tool context -c program.cr:2:3 program.cr
1 possible context found

| Expr    | Type         |
--------------------------
| x       | String | Nil |
| default |    String    |
```

It will give us a bit more of what we wanted since the type of all variables/parameters in the position of the cursor that was given will be shown.

It will also use only compile time information. The program is never executed in this case as opposed to the puts debug.

Unfortunately the tool will not allow us to print the type of any expression unless we assign it to a variable previously.

The context tool is a separate implementation that relies on the compiler but essentially traverse the whole compiled program. There are some edge cases that are currently not handled.

The most important shortcoming I think is the developer experience. It’s not great unless it’s integrated with an editor.

## Adding `reveal_type` to Crystal

The developer experience of Sorbet’s `reveal_type` is awesome:

- The modifications needed to the program are simple and can be applied to any valid expression.
- The same type checker is the one that show the information.
- There is no need to discover an internal tool command
- There is no need for additional editor integration
- It supports multiple `reveal_type` mentions in one pass.

I want the same for Crystal 🙂.

```crystal
def maybe(x, default)
  reveal_type(x) # what's x type here?
  if x
    x
  else
    default
  end
end
```

```console
% crystal build program.cr
Revealed type program.cr:2:15
  x : String | Nil
```

Or some similar output.

Before hacking the compiler I wanted to see if it can be done at user code.

Crystal macros can print during compile time and we have access to the expression’s AST.

The following will give us the first part of the message.


```crystal
{% raw %}
macro reveal_type(t)
  {% loc = "#{t.filename.id}:#{t.line_number}:#{t.column_number}" %}
  {% puts "Revealed type #{loc.id}" %}
  {% puts "  #{t.id}" %}
  {{t}}
end
{% endraw %}
```

If we try to get the compile-time type of the expression `t` we will stumble on the infamous “can't execute TypeOf in a macro”.


```console
{% raw %}
In program.ign.cr:4:26

  9 | {% puts "  #{t.id} : #{typeof(t)}" %}
                            ^
Error: can't execute TypeOf in a macro
{% endraw %}
```

To overcome this we can use the fact that `def`s can have macro code.


```crystal
{% raw %}
def reveal_type_helper(t : T) : T forall T
  {% puts "   : #{T}" %}
  t
end

macro reveal_type(t)
  {% loc = "#{t.filename.id}:#{t.line_number}:#{t.column_number}" %}
  {% puts "Revealed type #{loc.id}" %}
  {% puts "  #{t.id}" %}
  reveal_type_helper({{t}})
end
{% endraw %}
```

With this snippet at the top of our `program.cr` we already have the output we want. 🎉

```console
% crystal build program.cr
Revealed type /path/to/program.cr:14:15
  x
  : (String | Nil)
```

Unfortunately if we put multiple `reveal_type` invocations things will not work as expected. The macro at `reveal_type_helper` is executed only **once per distinct type**.

To force a different `reveal_type_helper` instance for each `reveal_type` invocation we would need a distinct type for each. Surprisingly we can do that.

```crystal
{% raw %}
def reveal_type_helper(t : T, l) : T forall T
  {% puts "   : #{T}" %}
  t
end

macro reveal_type(t)
  {% loc = "#{t.filename.id}:#{t.line_number}:#{t.column_number}" %}
  {% puts "Revealed type #{loc.id}" %}
  {% puts "  #{t.id}" %}
  reveal_type_helper({{t}}, { {{loc.tr("/:.","___").id}}: 1 })
end
{% endraw %}
```

The `l` argument will have a tuple of type `{ <loc>: Int32 }` where `<loc>` is an identifier that depends on the invocation location of the `reveal_type` macro. 🤯


## Caveats

There are a couple of more caveats of this solution that are worth mentioning. A proper built-in feature in the compiler would not be affected by all of them. Essentially these can be summed up as:


- The `reveal_type` needs to be within used code
- Our implementation is very sensible to the internals compiler’s execution order
- It doesn't handle fully recursive definitions
- It could change the semantic of the program since it affects the memory layout

Feel free to skip to the [next section](#ideas-for-the-compiler) unless you want any further details and examples of each.

Due to how Crystal compiler works, the `reveal_type` needs to appear within **static reachable code**. Even if you start in a `def` with arguments with types (type restrictions actually) you need that `def` to be called. Otherwise the compiler ignores it. Similar to how C++ templates are not expanded unless they are used.

Splitting the desired output between macro and defs is very sensible to the **compiler’s execution order**. The following code suffers from this:

```crystal
"a".tap do |a|
  reveal_type a
end

1.tap do |a|
  reveal_type a
end
```

```console
Revealed type /path/to/program.cr:2:15
  a
Revealed type /path/to/program.cr:6:15
  a
    : String
    : Int32
```

**Recursive** programs can hit an edge case that would hide the output of `reveal_type_helper`. The following program will have several `dig_first` instantiation. As such the `reveal_type` macro will be called once per each, but all of the `reveal_type_helper` invocations are with the same `t` type and in the same location. We fall again in the problem we solved earlier with the `{ <loc>: Int32 }` param.

```crystal
def dig_first(xs)
  case xs
  when Nil
    nil
  when Enumerable
    reveal_type(dig_first(xs.first))
  else
    xs
  end
end

dig_first([[1,[2],3]])
```

```console
Revealed type /path/to/program.cr:6:17
  dig_first(xs.first)
Revealed type /path/to/program.cr:6:17
  dig_first(xs.first)
Revealed type /path/to/program.cr:6:17
  dig_first(xs.first)
Revealed type /path/to/program.cr:6:17
  dig_first(xs.first)
    : (Int32 | Nil)
```

We mostly care about the compile-time experience here, but the `reveal_type_helper` invocation duplicates value-type values and **could change the semantic of the running program**.


```crystal
struct SmtpConfig
  property host : String = ""
end

struct Config
  property smtp : SmtpConfig = SmtpConfig.new
end

config = Config.new
config.smtp.host = "example.org"

pp! config # => Config(@smtp=SmtpConfig(@host="example.org"))
```

If we add a `reveal_type` around `config.smtp`

```crystal
reveal_type(config.smtp).host = "example.org"
```

We will alter the program output

```console
config # => Config(@smtp=SmtpConfig(@host=""))
```

We could do an alternative `reveal_type` implementation that will preserve the memory layout, but it fails even to compile the previous recursive program. Either way, the following would be that variation:


```crystal
{% raw %}
def reveal_type_helper(t : T, l) : Nil forall T
  {% puts "   : #{T}" %}
end

macro reveal_type(t)
  {% loc = "#{t.filename.id}:#{t.line_number}:#{t.column_number}" %}
  {% puts "Revealed type #{loc.id}" %}
  {% puts "  #{t.id}" %}
  %t = uninitialized typeof({{t}})
  reveal_type_helper(%t, { {{loc.tr("/:.","___").id}}: 1 })
  {{t}}
end
{% endraw %}
```

That’s it, no more caveats I can think of!

## Ideas for the compiler

It’s definitely feasible to implement better `reveal_type` in the compiler. It would require to reserve the method name for the compiler for a start.

Since it would not require a user defined macro/method it would not suffer from the issues exposed in the caveats.

But maybe there is something intermediate we can do to allow more use cases in the future.

In the `reveal_type` macro we needed to show the expression and its location. This is something that is already done in [`AST#raise`](https://crystal-lang.org/api/1.7.2/Crystal/Macros/ASTNode.html#raise%28message%29%3ANoReturn-instance-method). Unfortunately it’s not possible to tweak the output and it’s always treated as a compiler error:

```crystal
{% raw %}
macro reveal_type(t)
  {% t.raise "Lorem ipsum" %}
end
{% endraw %}
```

```console
In program.cr:24:1

  24 | reveal_type(config.smtp).host = "example.org"
      ^----------
Error: Lorem ipsum
```

If we would like to keep the `reveal_type` defined in user code I think it would be nice to have something similar to `AST#raise` to print information only. This could have the location, expression and `^-------` already solved, while allowing use to customize the message. Additionally,


- It could allow multiple information invocation and not abort the compilation as `AST#raise` does.
- It could have access to some additional information as final node type by having specific execution live-cycle: `AST#at_exit_info` for example.
- It could be used to experiment with additional compile-time tooling (eg: checking if a database and model is up-to-date with one another)

Some of these ideas resonate a lot with requests made by [paulcsmith](https://github.com/paulcsmith) of [Lucky](https://github.com/luckyframework/) on how to extend the compiler’s behavior. I expect that something like `AST#at_exit_info` or `AST#info` would be useful in that regard.

## Conclusions

The final shape of our solutions can be easily added in our Crystal app for development purposes.

```crystal
{% raw %}
def reveal_type_helper(t : T, l) : T forall T
  {% puts "   : #{T}" %}
  t
end

macro reveal_type(t)
  {% loc = "#{t.filename.id}:#{t.line_number}:#{t.column_number}" %}
  {% puts "Revealed type #{loc.id}" %}
  {% puts "  #{t.id}" %}
  reveal_type_helper({{t}}, { {{loc.tr("/:.","___").id}}: 1 })
end
{% endraw %}
```

If we have an expression like `foo(bar.baz)` in which we are uncertain about the type of `bar` we can:


1. Surround `bar` with `reveal_type` as in `foo(reveal_type(bar).baz)`
2. Build the program as usual.
3. See the compiler output as

```console
Revealed type /path/to/program.cr:14:15
  bar
    : (String | Nil)
```

As mentioned earlier, there are a couple of caveats with this solution but I think it works for vast majority of cases. It was great to extend somehow the compiler tooling via user code only.

It would be great to have some feedback if a proper built-it alternative of this would be valuable.
