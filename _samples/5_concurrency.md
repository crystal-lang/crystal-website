---
title: Concurrency Model
short_name: Concurrency
description: |
  Crystal uses green threads, called fibers, to achieve concurrency. Fibers communicate with each other using channels, as in Go or Clojure, without having to turn to shared memory or locks.
read_more: "[Read more about Crystal's concurrency model](https://crystal-lang.org/reference/guides/concurrency.html)"
weight: 4
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
