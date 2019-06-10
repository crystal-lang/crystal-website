---
title: "Formatting pretty numbers for humans"
summary: "Crystal 0.28.0 comes with new features for formatting neat numbers for human readers."
thumbnail: W
author: straight-shoota
---

With Crystal 0.28.0 we have a new feature for formatting numbers for human readers.

Previously the options were using `#to_s` on various `Number` types or at best [`sprintf`](https://crystal-lang.org/api/0.28.0/toplevel.html#sprintf%28format_string%2C%2Aargs%29%3AString-class-method). Both provide only limited output formats and they're focused on how numbers are represented for computers. They don't have readability for humans in mind.

When showing numbers in a user interface, they need to be understandable by human readers.

# Format a Number

Meet the new [`Number#format`](https://crystal-lang.org/api/0.28.0/Number.html#format%28separator%3D%26%2339%3B.%26%2339%3B%2Cdelimiter%3D%26%2339%3B%2C%26%2339%3B%2Cdecimal_places%3AInt%3F%3Dnil%2C%2A%2Cgroup%3AInt%3D3%2Conly_significant%3ABool%3Dfalse%29%3AString-instance-method) method.

It allows printing numbers in a customizable format, that can represent the way that numbers are usually written for humans. 

## Number styles

Numbers can be formatted using configurable decimal separator and thousands delimiter:

<div class="code_section">{% highlight crystal %}
123_456.789.format('.', ',')   # => "123,456.789"
123_456.789.format(',', '.')   # => "123.456,789"
123_456.789.format(',', ' ')   # => "123 456,789"
123_456.789.format(',', '\'')  # => "123'456,789"
{% endhighlight crystal %}</div>

The number of digits in a thousands group is also configurable. This works for example for Chinese numbers grouped by tenthousands:

<div class="code_section">{% highlight crystal %}
123_456.789.format('.', ',', group: 4) # => "12,3456.789"
{% endhighlight crystal %}</div>

There are many different styles used in different cultural contexts, and this method is flexible enough to represent most common formats.

[*How the world separates its digits*](http://www.statisticalconsultants.co.nz/blog/how-the-world-separates-its-digits.html) provides an overview of international styles, and the [Wikipedia article on *Decimal Separators*](https://en.wikipedia.org/wiki/Decimal_separator) provides some more insight on this topic.

## Decimal places

Floating point numbers can produce a lot of decimal places when converted to a human-readable string. For user output such detail is usually a distraction and displaying a few decimal places is plenty.

The number of decimal places can be configured directly in the `#format` method:

<div class="code_section">{% highlight crystal %}
123_456.789.format(decimal_places: 2) # => "123,456.79"
123_456.789.format(decimal_places: 0) # => "123,457"
123_456.789.format(decimal_places: 4) # => "123,456.7890"
{% endhighlight crystal %}</div>

Compared to rounding the value manually before formatting it, this is easier and allows for more options.

The number of decimal places is fixed by default. Trailing zeros will only be omitted when `only_significant` is `true`:

<div class="code_section">{% highlight crystal %}
123_456.789.format(decimal_places: 6)                         # => "123,456.789000"
123_456.789.format(decimal_places: 6, only_significant: true) # => "123,456.789"
{% endhighlight crystal %}</div>

# Humanize a Number

When numbers of different orders of magnitude are put in relation, it's difficult to represent a large range of values in a meaningful way.

In such cases, it's common to express the magnitude of a value using a quantifier.

For this we have [`Number#humanize`](https://crystal-lang.org/api/0.28.0/Number.html#humanize%28precision%3D3%2Cseparator%3D%26%2339%3B.%26%2339%3B%2Cdelimiter%3D%26%2339%3B%2C%26%2339%3B%2C%2A%2Cbase%3D10%2A%2A3%2Csignificant%3Dtrue%2Cprefixes%3DSI_PREFIXES%29%3AString-instance-method): It rounds the number to the nearest thousands magnitude with a specific number of significant digits.

<div class="code_section">{% highlight crystal %}
1_200_000_000.humanize # => "1.2G"
0.000_000_012.humanize # => "12.0n"
{% endhighlight crystal %}</div>

It has the same arguments for decimal `separator` and thousands `delimiter` as `Number#format`, so the style is configurable exactly the same way.

The number of significant digits can be adjusted by `precision`. But the default value `3` is probably already a good fit for most applications.
When `siginficant` is `true`, the value of `precision` is the fixed amount of decimal digits regardless of the number's value.

Quantifiers are by default the SI prefixes (`k`, `M`, `G`, etc.), but they're completely configurable, either by providing a list, or a proc.

## Customizable quantifiers

`Number#humanize` can take a proc argument that calculates the number of digits and the quantifier for a specific magnitude.

The following example shows how to format a length in metric units, including the unit designator. It derives from the default implementation by using the common *centimeter* unit for values between `0.01` and `0.99` (which the generic mapping would express as *millimeter*). All other values use the generic SI prefixes (provided by [`Number.si_prefix`](https://crystal-lang.org/api/0.28.0/Number.html#si_prefix(magnitude:Int,prefixes=SI_PREFIXES):Char?-class-method)).

<div class="code_section">{% highlight crystal %}
def humanize_length(number)
  number.humanize do |magnitude, number|
    case magnitude
    when -2, -1 then {-2, " cm"}
    else
      magnitude = Number.prefix_index(magnitude)
      {magnitude, " #{Number.si_prefix(magnitude)}m"}
    end
  end
end

humanize_length(1_420) # => "1.42 km"
humanize_length(0.23)  # => "23.0 cm"
humanize_length(0.05)  # => "5.0 cm"
humanize_length(0.001) # => "1.0 mm"
{% endhighlight crystal %}</div>

# Humanize Bytes

The third method is [`Int#humanize_bytes`](https://crystal-lang.org/api/0.28.0/Int.html#humanize_bytes%28precision%3AInt%3D3%2Cseparator%3D%26%2339%3B.%26%2339%3B%2C%2A%2Csignificant%3ABool%3Dtrue%2Cformat%3ABinaryPrefixFormat%3D%3AIEC%29%3AString-instance-method) which allows formatting a number of bytes (for example memory size) in a typical format. It supports both IEC (`Ki`, `Mi`, `Gi`, `Ti`, `Pi`, `Ei`, `Zi`, `Yi`) and JEDEC (`K`, `M`, `G`, `T`, `P`, `E`, `Z`, `Y`) prefixes.

<div class="code_section">{% highlight crystal %}
1.humanize_bytes                          # => "1B"
1024.humanize_bytes                       # => "1.0kiB"
1536.humanize_bytes                       # => "1.5kiB"
524288.humanize_bytes(format: :JEDEC)     # => "512kB"
1073741824.humanize_bytes(format: :JEDEC) # => "1.0GB"
{% endhighlight crystal %}</div>

The [implementation of this method](https://github.com/crystal-lang/crystal/blob/639e4765f3f4137f90c5b7da24d8ccb5b0bfec35/src/humanize.cr#L304) is another example for a custom format based on `Numer#humanize`.

# Summary

These new methods provide great features for making numbers look pretty to the reader.

They do not provide style mappings for specific locales. This is a non-trivial task that should be left for dedicated I18N libraries. But they're useful building blocks that such libraries can build upon. And they're immediatetly usable when you don't need to support different locales.

The implementation is not perfect, though. Localization is complex and hard to get right. As always, the devil lies in the details. For example, the thousands delimiter and group size are configurable, but have fixed values. The [Indian numbering system](https://en.wikipedia.org/wiki/Indian_numbering_system) can't be represented in this way. Then only arabic numbers are supported. And there are probably lots of other cases which would require more specialiced behaviour.

But it's probably good for more than 90% of typical use cases, and already useful in many places. And there is always room for improvement.

More background information can be found in the [PR which brought these features](https://github.com/crystal-lang/crystal/pull/6314).

Also a good read on formatting numbers from a more general perspective: [Formatting numbers for machines and mortals](https://medium.com/@hjalli/formatting-numbers-for-machines-and-mortals-421860e68db3) by Hjalmar Gislason.
