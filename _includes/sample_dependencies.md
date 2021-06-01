{% highlight yaml %}
name: my-project
version: 0.1
license: MIT

crystal: {{ site.latest_release.version }}

dependencies:
  mysql:
    github: crystal-lang/crystal-mysql
    version: ~> 0.3.1
{% endhighlight %}
