---
short_name: Rich stdlib
title: Batteries included
description: |
  Crystal's standard library comes with a whole range of libraries that let you start working on your project right away.
read_more: '[Check the API docs](https://crystal-lang.org/api/)'
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
