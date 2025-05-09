---
short_name: Rich stdlib
title: Batteries included
description: |
  Crystal's standard library comes with a whole range of libraries that let you start working on your project right away.
read_more: '[Check the API docs](https://crystal-lang.org/api/)'
playground: false
---
```crystal
require "http/client"
require "xml"

response = HTTP::Client.get("https://crystal-lang.org")
html = XML.parse(response.body)
node = html.xpath_node(%(//div[@class="latest-release-info"]//strong))
version = node.try(&.text)

puts "Latest Crystal version: #{version || "Unknown"}"
```
