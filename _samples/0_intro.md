---
short_name: Intro
title: ""
description: |
  Crystal is a general-purpose, object-oriented programming language.
  With syntax inspired by Ruby, it’s a compiled language with static type-checking.
  Types are resolved by an advanced type inference algorithm.
read_more: '[Language specification](https://crystal-lang.org/reference/syntax_and_semantics/)'
playground: false
---
```crystal
# A very basic HTTP server
require "http/server"

server = HTTP::Server.new do |context|
  context.response.content_type = "text/plain"
  context.response.print "Hello world, got #{context.request.path}!"
end

address = server.bind_tcp(8080)
puts "Listening on http://#{address}"

# This call blocks until the process is terminated
server.listen
```
