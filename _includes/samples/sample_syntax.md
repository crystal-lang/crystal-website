{% highlight crystal %}
def longest_repetition(string)
  max = string
          .chars
          .chunk(&.itself)
          .map(&.last)
          .max_by(&.size)

  max ? {max[0], max.size} : {"", 0}
end

# press ▶️ and check the result 
puts longest_repetition("aaabb")
{% endhighlight %}
