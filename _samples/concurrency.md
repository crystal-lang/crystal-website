---
title: Concurrency Model
short_name: Concurrency
description: >
  Crystal uses green threads, called fibers, to achieve concurrency. Fibers communicate with each other using channels, as in Go or Clojure, without having to turn to shared memory or locks.
read_more_url: https://crystal-lang.org/reference/guides/concurrency.html
read_more_label: Read more about Crystal's concurrency model
tags: concurrency
---
```crystal
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
```
