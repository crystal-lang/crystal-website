---
title: Living Style Guide
layout: page-wide
permalink: /style-guide/
section: internal
---

<div class="container">
A handy collection of all the colors, typography, UI patterns, and components of this website.

Where applicable links to a component's Sass partial and/or Jekyll include are provided, along with short descriptions of typical usage.
</div>

{% assign componentsByType = site.style_guide | group_by: "type" %}

<div class="container">
  <ul>
    {% for type in componentsByType %}
      <li>
        <a href="#{{ type.name }}">{{ type.name | capitalize }}</a>
      </li>
    {% endfor %}
  </ul>
</div>

{% for type in componentsByType %}
<h2 id="{{ type.name }}" class="cf">{{ type.name | capitalize }}</h2>
{% for component in type.items %}
{% include style-guide/component.html %}
{% endfor %}
{% endfor %}
