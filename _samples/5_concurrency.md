---
title: Concurrency Model
short_name: Concurrency
description: |
  Crystal uses green threads, called fibers, to achieve concurrency.
  Fibers communicate with each other via channels without having to turn to shared memory or locks ([CSP](https://www.wikiwand.com/en/Communicating_sequential_processes)).
read_more: "[Read more about concurrency](https://crystal-lang.org/reference/guides/concurrency.html)"
---
```crystal
channel = Channel(Int32).new

3.times do |i|
  spawn do
    3.times do |j|
      sleep rand(100).milliseconds # add non-determinism for fun
      channel.send 10 * (i + 1) + j
    end
  end
end

9.times do
  puts channel.receive
end
```
