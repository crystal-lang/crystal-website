---
title: Success stories
section: blog
layout: page-wide
link_actions:
- '[Used in production](/used_in_prod/)'
---

<section>
  <div class="posts-list">
    {%- for post in site.categories.success_stories %}
    <article class="post-card">
      <img src="{{ post.image }}" alt="">
      <span class="company">{{ post.company }}</span>
      <a href="{{ post.url }}" class="name">
        {{- post.title }}
      </a>
    </article>
    {%- endfor %}
  </div>
</section>
