---
title: News
excerpt: Blog posts
layout: wide
section: blog
link_actions:
- |
  <a href="/feed.xml" rel="alternate" title="Newsfeed for Crystal blog posts" aria-label="Blog newsfeed" type="application/atom+xml">
    RSS
  </a>
- "[Tags](blog/tags.md)"
---

{% include posts/featured_news.html %}

{% include posts/recent_news.html offset=1 %}

{% include posts/more_articles.html posts=posts %}
