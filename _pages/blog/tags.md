---
title: Tags
layout: page
section: tags
---

{% capture counts_with_tags_string %}{% for tag in site.tags %}{{ tag[1] | size | prepend:"000000" | slice:-6,6 }}:{{ tag[0] }}{% unless forloop.last %},{% endunless %}{% endfor %}{% endcapture %}
{% assign counts_with_tags = counts_with_tags_string | split:"," | sort | reverse %}

{% for count_with_tag in counts_with_tags %}
  {% assign tag = count_with_tag | split:":" | last %}
  {% assign posts = site.tags[tag] %}
<div>
  <div>
    {% assign count = posts | size %}
    <a href="/blog/tags/{{ tag | slugify }}" class="tag">#{{ tag }}</a>{% if count > 1 %} <small>({{ count }} posts)</small>{% endif %}
  </div>
  <div style="margin-top: 0;">
  <ul>
    {% for post in posts limit: 3 %}
      <li>
        <time class="post-date" pubdate datetime="{{ post.date | date_to_xml }}"
    >{{ post.date | date_to_string }}</time>
        <a href="{{ post.url }}">{{ post.title }}</a>
      </li>
    {% endfor %}
  </ul>
  </div>
</div>
{% endfor %}
