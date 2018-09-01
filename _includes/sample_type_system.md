{% highlight crystal %}
def shout(x)
  # Notice that both Int32 and String respond_to `to_s`
  x.to_s.upcase
end

foo = ENV["FOO"]? || 10

typeof(foo) # => (Int32 | String)
typeof(shout(foo)) # => String
{% endhighlight %}
