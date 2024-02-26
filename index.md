---
title: Crystal
layout: home
section: home
---

<h2 class="visually-hidden">News</h2>

{% include posts/recent_news.html %}

<div class="link-actions">
  <a href="/blog/">More news</a>
  <a href="/feed.xml">Feed</a>
  <a href="/releases/">Release notes</a>
</div>

<hr class="full-width-rule">

{% include components/sponsorship.html %}

{% include components/top-sponsors.html %}

## Success stories

{% include components/posts-list.html posts=site.categories.success limit=3 %}

<div class="link-actions">
  <a href="/success-stories/">More success stories</a>
  <a href="/used_in_prod/">Used in production</a>
</div>
