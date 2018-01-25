---
title: "Amber - Crystalizing Rails and Phoenix"
author: robacarp
description: "Join Robert Carpenter, member of the Amber core team, in an introduction to this Rails-like web framework"
---

> _This guest post by [Robert Carpenter](https://github.com/robacarp) will introduce you to Amber, a Rails/Phoenix-like web framework for Crystal. Don't forget to [reach out to us](http://twitter.com/intent/tweet?text=@CrystalLanguage%20I%20want%20to%20write%20about...) if you want to share some experience of your own._

The [Amber Framework](https://amberframework.org) is a young and growing web framework written in our favorite language, Crystal. It shares many similarities with Rails, but - like Crystal itself - compatibility with Rails is not a design goal.

Here are a few reasons why I <3 Amber:

- Familiar framework design
- Compile time checks that save your sanity and maybe even your soul
- Open and welcoming framework development team
- Raw Speed

# Familiar Framework Design

Amber projects follow similar design to Rails and other MVC focused web frameworks. It borrows organization and concepts where they’re successful and builds on that foundation where developer efficiency or simplicity can be improved.

Rails veterans will recognize many of these files and folders immediately:

<div class="code_section">
{% highlight plaintext %}
.. (up a dir)
</repositories/offline_pink/
▸ db/migrations/
▾ src/
  ▾ controllers/
  	application_controller.cr
  	user_controller.cr
  ▸ mailers/
  ▾ models/
  	user.cr
  ▾ views/
	▾ user/
    	  new.slang
    	  show.slang
{% endhighlight %}
</div>

Models, views, controllers, and migrations are all right where you’d expect them. You’ll feel right at home. Environment config files follow a familiar style and a working asset pipeline is available right out of the box, if you want it (thanks to webpack).

# Compile Time checks
Thanks to Crystal, a large portion of an Amber project is evaluated at compile time. Never again get an email from production complaining about something so mundane as a `Missing Template`, `controller#action missing`, or `Undefined method .downcase for nil:NilClass`.

Amber even parses and compiles templates and layout files which not only verifies that the code is calling methods and getters safely, it saves a lot of time during a request.

Crystal does a great job of complaining when a method call on a variable isn’t valid for all possible types of that variable. Amber uses that power to ensure the application isn’t going to break at runtime wherever possible.

Observe what happens when compiling an Amber application with this broken template:

<div class="code_section">
{% highlight ruby %}
- if domain.nam.blank?
  p No domain name
{% endhighlight %}
</div>

The compiler complains, notifies you of the problem, and even suggests a correction:

<div class="code_section">
{% highlight ruby %}
in macro 'macro_4598546880' expanded macro: embed:1, line 1:

>  1. if domain.nam.blank?
   2. __kilt_io__ << "
   3. "
   4. __kilt_io__ << "<p"
   5. __kilt_io__ << ">"
   6. __kilt_io__ << HTML.escape(("No domain name").to_s).to_s(__kilt_io__)
   7. __kilt_io__ << "</p>"
   8. end

undefined method 'nam' for Domain (did you mean 'name'?)
{% endhighlight %}
</div>

These compile time checks can save your sanity when an accidental typo slips its way into your routes file, or accidentally forgetting to commit a view template.

# Open and welcoming dev team
The Amber project is _active_. Development on the tools, framework, libraries, and documentation is constant. Yet I've felt welcomed into the fold as an Amber contributor as the core team readily reviews and merges my pull requests, discusses framework direction and goals, and openly accepts suggestions and contributions from casual contributors as well as frequent benefactors.
This picture is from the [Github Pulse](https://github.com/amberframework/amber/pulse/monthly) and shows how active the project has been this month:

<img src="{{ 'blog/amber-pulse.png' | asset_path }}" class="center"/>

# Raw Speed
Last but certainly not least, thanks to Crystal, Amber is _**fast**_. The compiled web is real, and it’s far more friendly now than ever before.

Check out this log excerpt from a project I've been working on:

<div class="code_section">
{% highlight plaintext %}
10:49:15 Request	| Started 2018-01-11 10:49:15 -07:00
10:49:15 Request	| Status: 200  Method: GET  Pipeline: web Format: html
10:49:15 Request	| Requested Url: /domain/30
10:49:15 Request	| Time Elapsed: 17.52ms
{% endhighlight %}
</div>

This particular request is _slow_ by Amber standards, but it checks all the boxes:

- SELECT queries across several tables[^select]
- validating logged-in user session, and authenticating access for the request[^validating]
- rendering html views (not just JSON)[^rendering]

Compare to a page with similar database and rendering overhead in a Rails 5 application:

<div class="code_section">
{% highlight plaintext %}
processing by BookmarksController#index as HTML
Completed 200 OK in 251ms (Views: 217.9ms | ActiveRecord: 15.9ms)
{% endhighlight %}
</div>

That's right. Thanks to the speed of Crystal, Amber can complete an entire request in about the same amount of time it takes Rails to query the database. That means each server can handle more traffic, is more resilient to denial of service, and every page is more responsive[^unedited-logs].

For a real sample of speed, this excerpt is from a basic Read route such as this:

<div class="code_section">
{% highlight ruby %}
  def profile
    user = current_user
    render "show.slang"
  end
{% endhighlight %}
</div>

<div class="code_section">
{% highlight plaintext %}
01:19:11 Request    | Started 2018-01-11 13:19:11 -07:00
01:19:11 Request    | Status: 200  Method: GET  Pipeline: web Format: html
01:19:11 Request    | Requested Url: /my/profile
01:19:11 Request    | Time Elapsed: 1.75ms
{% endhighlight %}
</div>

Or even faster, serving a static file:

<div class="code_section">
{% highlight plaintext %}
01:19:11 Request    | Started 2018-01-11 13:19:11 -07:00
01:19:11 Request    | Status: 200  Method: GET  Pipeline: static Format:
01:19:11 Request    | Requested Url: /dist/main.bundle.js
01:19:11 Request    | Time Elapsed: 329.0µs
{% endhighlight %}
</div>

Amazingly, because Amber views are compiled in, rendering a template and layout can be _significantly faster_ than serving static files when the application is configured for it[^configuration]:

<div class="code_section">
{% highlight plaintext %}
01:45:15 Request	| Started 2018-01-17 13:45:15 -07:00
01:45:15 Request	| Status: 200  Method: GET  Pipeline: web Format: html
01:45:15 Request	| Requested Url: /
01:45:15 Request	| Time Elapsed: 371.0µs
01:45:16 Request	| Started 2018-01-17 13:45:15 -07:00
01:45:16 Request	| Status: 200  Method: GET  Pipeline: static Format: js
01:45:16 Request	| Requested Url: /dist/main.bundle.js
01:45:16 Request	| Time Elapsed: 80.01ms
{% endhighlight %}
</div>

No matter what your application is doing, Amber can do it _faster_.

# Summary
A lot of software is written for the web today. Ruby and Rails showed the world that development doesn't need to be painful for developers. Crystal is a language where development ease meets speed, and Amber is a framework built on that tradition. Developer friendliness meets raw speed and power, for the web. Or to borrow from Amber’s tag-line: Productivity. Performance. Happiness.

[^select]: [Relevant log](https://gist.github.com/robacarp/d20ed807003d96e76a8538fab17e8af5#file-ab_crystal_logs-txt-L1)
[^validating]: [Relevant log](https://gist.github.com/robacarp/d20ed807003d96e76a8538fab17e8af5#file-crystal_controller-cr)
[^rendering]: [Relevant log](https://gist.github.com/robacarp/d20ed807003d96e76a8538fab17e8af5#file-crystal_view-slim)
[^unedited-logs]: Unedited logs and code samples comparing Rails and Amber [here](https://gist.github.com/robacarp/d20ed807003d96e76a8538fab17e8af5)
[^configuration]: In order to render templates and views as fast as possible, the route pipeline must be slimmed down to almost nothing, rendering many features inoperable.
