{% highlight crystal %}
class Object
  def has_instance_var?(name) : Bool
    {% raw %}{{ @type.instance_vars.map &.name.stringify }}{% endraw %}.includes? name
  end
end

class Person
  property name : String
  
  def initialize(@name)
  end
end

person = Person.new "John"
p! person.has_instance_var?("name") # => true
p! person.has_instance_var?("birthday") # => false
{% endhighlight %}
