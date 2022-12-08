---
title: Batteries included
description: >
  Crystal's API includes a whole range of classes to let you start working on your project with minimal dependencies.
read_more_url: https://crystal-lang.org/api/
read_more_label: Check the API
tags: batteries_included
playground: false
---
```crystal
# A very basic HTTP server
require "http/server"

server = HTTP::Server.new do |context|
  context.response.content_type = "text/plain"
  context.response.print "Hello world, got #{context.request.path}!"
end

puts "Listening on http://127.0.0.1:8080"
server.listen(8080)

# (This example can't be run from carc.in)
```
