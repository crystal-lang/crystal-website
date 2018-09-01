{% highlight crystal %}
class Object
  def has_instance_var?(name) : Bool
    {% raw %}{{ @type.instance_vars.map &.name.stringify }}{% endraw %}.includes? name
  end
end

person = Person.new "John", 30
person.has_instance_var?("name") #=> true
person.has_instance_var?("birthday") #=> false
{% endhighlight %}
