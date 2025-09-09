---
title: Crystal Newsletter
section: newsletter
description: |
  Our newsletter regularly shares highlights and insights on the Crystal language and community.
---

<h3>Latest edition</h3>

{% for issue in site.newsletter limit: 1 %}
<a href="{{ issue.url }}">{{ issue.title}}</a> ({{ issue.date | date_to_string }})

{{ issue.intro | markdownify }}

{% endfor %}

{%- include site/newsletter-form.html %}

<h3>Previous issues</h3>
<ul>
{% for issue in site.newsletter %}
  <li>
    <a href="{{ issue.url }}">{{ issue.title}}</a> ({{ issue.date | date_to_string }})
  </li>
{% endfor %}
</ul>
