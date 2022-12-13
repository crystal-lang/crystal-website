{% highlight crystal %}
channel = Channel(Int32).new
total_lines = 0
files = Dir.glob("*.txt")

files.each do |f|
  spawn do
    lines = File.read_lines(f)
    channel.send lines.size
  end
end

files.size.times do
  total_lines += channel.receive
end

puts total_lines
{% endhighlight %}
