---
title: Concurrency Model
description: |
  Crystal uses green threads, called fibers, to achieve concurrency.
  Fibers communicate with each other using channels, as in Go or Clojure,
  without having to turn to shared memory or locks.
read_more_url: https://crystal-lang.org/reference/guides/concurrency.html
read_more_label: Read more about Crystal's concurrency model
runnable: true
---
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
