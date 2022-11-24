{% highlight crystal %}
channel = Channel(Int32).new
total_lines = 0

sites = ["http://www.example.com", "http://info.cern.ch/"]

sites.each do |site|
  spawn do
    channel.send site.size
  end
end

sites.size.times do
  total_lines += channel.receive
end

puts total_lines
{% endhighlight %}
