---
title: Code Block
type: typography
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
```

```yaml
name: my-project
version: 0.1
license: MIT

crystal: 1.3.0

dependencies:
  mysql:
    github: crystal-lang/crystal-mysql
```

All types are non-nilable in Crystal, and nilable variables are represented as a union between the type and nil.

```
if rand(2) > 0
  my_string = "hello world"
end

puts my_string.upcase
```

```terminal
$ crystal build hello-world.cr
$ ./hello-world
Hello World!
```
