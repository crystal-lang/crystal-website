{% highlight crystal %}
def shout(x)
  # Notice that both Int32 and String respond_to `to_s`
  x.to_s.upcase
end

# If `ENV["FOO"]` is defined, use that, else `10`
foo = ENV["FOO"]? || 10

puts typeof(foo) # => (Int32 | String)
puts typeof(shout(foo)) # => String
{% endhighlight %}
