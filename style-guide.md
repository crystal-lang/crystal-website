---
title: Living Style Guide
layout: page
permalink: /style-guide/
---

<div class="container">
A handy collection of all the colors, typography, UI patterns, and components of this website.

Where applicable links to a component's Sass partial and/or Jekyll include are provided, along with short descriptions of typical usage.
</div>

{% assign componentsByType = site.style_guide | group_by: "type" %}

{% for type in componentsByType %}
<h2 id="{{ type.name }}" class="cf">{{ type.name | capitalize }}</h2>
{% for component in type.items %}
{% include style-guide/component.html %}
{% endfor %}
{% endfor %}
