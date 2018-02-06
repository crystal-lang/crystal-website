---
title: "Lucky with Crystal - Fewer Bugs, Better Performance, Incredible Productivity"
author: paulcsmith
description: "Lucky is a new Crystal web framework built to catch bugs at compile time, return responses incredibly quickly, and help you write maintainable code."
---

> _[Paul Smith](https://github.com/paulcsmith) created the [**Lucky web framework**](https://luckyframework.org/) a year ago - and he now shares its status with us. If you want to share your own project, [**reach out to us**](http://twitter.com/intent/tweet?text=@CrystalLanguage%20I%20want%20to%20write%20about...) with your idea._

[Lucky](https://luckyframework.org) is a full-featured web application framework written in Crystal. You will write fewer tests and have fewer bugs when using Lucky because of its type-safe querying, routing and record saving. With that saved time, you will be able to focus on building the best app possible.

## Week 1 to Week 1,000

When I start an app with most frameworks, I’m hopeful. I see the potential that the product has, and based on the first few weeks of progress, things will go incredibly smoothly.

Months pass...

My hope for the wonderful future of the product turns into hope that the latest commits won’t break anything.

I begin to focus more on how my changes might cause a bug than how to make the app better. *I write and run tests, hoping that I thought of everything that could be an issue.* It  becomes harder and harder to keep simple and understandable.

## Lucky helps you focus on building your app

**Instead of spending all your energy worrying about all the ways things might not work, let the computer help. After all, that’s its job.**

[Lucky’s route handling](https://robots.thoughtbot.com/designing-lucky-actions-routing), [record saving](https://luckyframework.org/guides/saving-with-forms/), and [querying](https://luckyframework.org/guides/querying-the-database/) are all type-safe. Even the configuration will cause failures at compile time, so you know you haven’t accidentally messed anything up when upgrading dependencies.

This  allows you to focus on how to delight your customers with a speedy, reliable, and value-packed web application.

## Alright, so how does Lucky catch bugs that other frameworks won’t?

### Type safe querying

Let’s say we want to get all users whose names include “kat”. Here’s how we’d do it in Lucky:

<div class="code_section">
{% highlight ruby %}
# Will find users with the name "Kathryn", "Katy", etc.
UserQuery.new.name.ilike("kat%")
{% endhighlight %}
</div>

In Lucky you’ll get methods specific to the type of the column. This means that methods like  `lower` and `ilike` are only available for String columns. If you tried to call `lower` on an integer column by accident, Lucky will let you know at compile time. If you rename the `name` column to `full_name`, Lucky will show you all the places where you also need to make that change at compile-time.

If you try to pass `nil` to a column that doesn’t allow `nil`, Lucky will let you know at compile time so you can avoid dreaded logical errors and `nil` errors.

### Never worry about the HTTP verb again

One of the more annoying issues in Rails is forgetting to set the right HTTP method for a link, even when you have the path correct.

Here’s an example for deleting a comment:

<div class="code_section">
{% highlight ruby %}
link_to "Delete", comment_path(@comment)
{% endhighlight %}
</div>

*Can you spot the issue?* The path is right, but I forgot to specify the HTTP verb. This is especially confusing for team members that are new to web development or REST.

*In Lucky, the HTTP verb is automatically used in links, forms, and buttons. You never have to even think about it.* It just works.

The right verb (DELETE) is automatically set for you:

<div class="code_section">
{% highlight ruby %}
link "Delete comment", to: Comment::Delete.with(@comment.id)
{% endhighlight %}
</div>

### Catch missing conditionals in actions

Let’s say you have any action with a conditional like this:

<div class="code_section">
{% highlight ruby %}
class SamlSignIns::Create < BrowserAction
  action do
    if user.present? && sso_enabled?
      redirect to: SamlSignIns::New
    elsif user.present? && !sso_enabled?
      flash.info = "This email address does not have SSO enabled"
      redirect to: SignIns::New
    end
  end
end
{% endhighlight %}
</div>

*Lucky will catch a bug for you and give you a helpful message to guide you in the right direction:*

<div class="code_section">
{% highlight ruby %}
SamlSignIns::Create returned Lucky::Response | Nil, but it must return a Lucky::Response.

Try this...

  ▸ Make sure to use a method like `render`, `redirect`, or `json` at the end of your action.
  ▸ If you are using a conditional, make sure all branches return a Lucky::Response.
{% endhighlight %}
</div>

In this case, we forgot to add an `else` condition that lets the user know that we couldn’t find a user account for them. Lucky is helpful enough to help guide us toward this solution.

> This is just a taste of what Lucky can do to help you focus on building the best app possible. Check out “[Why Lucky?](https://luckyframework.org/why-lucky)” and “[Designing Lucky: Rock Solid Actions & Routing](https://robots.thoughtbot.com/designing-lucky-actions-routing)” to learn more.


## Give Lucky a spin

We have designed Lucky to help people avoid common pitfalls, and make programming fun years into a project. If you’re interested in Lucky, [throw us a star on the Github](https://github.com/luckyframework/lucky), [check out the guides](https://luckyframework.org/guides/), or [learn more about what makes Lucky special](https://luckyframework.org/why-lucky/). Happy coding!
