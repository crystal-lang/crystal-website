---
title: INSERT INTO shard VALUES ("crystal-db")
summary: One db api to rule them all
thumbnail: DB
author: bcardiff
---

Using a database is a really common task. For each kind of database there is a shard or library needed. When there is no common API to talk to a database, building more advanced shards like orm or migrations is harder. Either you end up supporting just a driver or you need to create a whole ad-hoc solution. Lacking a common api also means that when changing from one DB to another you will need to learn a different api. You already unavoidably need to deal with some SQL differences: `?`/`$1`, `TOP`/`LIMIT`, etc.

Some time ago we started [crystal-lang/crystal-db](https://github.com/crystal-lang/crystal-db) to build a unified database API.

**We are proud to announce that we have reached the point where it is no longer a proof-of-concept**. We are excited to share the latest news, and encourage you to use and break things.

The role of `crystal-db` is to abstract from SQL DB drivers which will implement bindings or even raw protocols using [Socket](https://crystal-lang.org/api/Socket.html).

Current `crystal-db` implementations are:

* [crystal-lang/crystal-sqlite3](https://github.com/crystal-lang/crystal-sqlite3) that binds libsqlite3.
* [crystal-lang/crystal-mysql](https://github.com/crystal-lang/crystal-mysql) that talks to MySQL using a **100% crystal** implementation.
* [will/crystal-pg](https://github.com/will/crystal-pg) that talks to PostgreSQL using a **100% crystal** implementation.

**Why are 100% crystal implementations important?** Usually this means:

* Less pain with binary dependencies,
* You can go down the rabbit hole with protocols.

But even more important:

* Reduce memory footprint,
* Read/write directly on the socket to the server without leaving the joy of the language,
* Take advantage of all the native async I/O in crystal, thus not blocking the current fiber.

Also, besides a unified query API, `crystal-db` ships with a connection pool, prepared statements, and nested transactions.

However, keep in mind that the role is not to abstract the particularities of different SQL dialects: while the shard provides a common API for writing SQL queries as strings, it does not attempt to analyse and manipulate the SQL code itself

## Next steps

We need to improve [the documentation](http://crystal-lang.github.io/crystal-db/api/latest/). Besides using `crystal docs`, [a new section was added](https://crystal-lang.org/reference/database/index.html) to [crystal-book](https://github.com/crystal-lang/crystal-book) that will continue to grow in the near future.

We hope this will help build DB tools and shards that work with multiple drivers, and that it will encourage more people to build their own drivers.

## Special thanks

* To [@spalladino](https://github.com/spalladino), [@asterite](https://github.com/asterite), [@waj](https://github.com/waj) for reviewing and discussing the code.
* To [@will](https://github.com/will) for joining the game.
* To the early adopters [@crisward](https://github.com/crisward), [@raydf](https://github.com/raydf), [@drujensen](https://github.com/drujensen), [@fridgerator](https://github.com/fridgerator), [@tbrand](https://github.com/tbrand) and many others.


