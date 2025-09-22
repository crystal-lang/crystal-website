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
require "json"

response = HTTP::Client.get("https://crystal-lang.org/api/versions.json")
json = JSON.parse(response.body)
version = json["versions"].as_a.find! { |entry| entry["released"]? != false }["name"]

puts "Latest Crystal version: #{version || "Unknown"}"
```
