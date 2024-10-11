---
title: Used in production
description: |
  Companies and individuals all over the world are using Crystal in production
  for projects of all kinds.
  Let us know that you are also using Crystal in production at your company or project, and we’ll add you to this list.
layout: page-wide
section: community
link_actions:
  - '[![](/assets/icons/forms_add_on.svg) Add me to the list](https://airtable.com/shrapvn1N02qwkowQ)'
sections:
  - name: Bioinformatics
    description: |
      Projects dedicated to methods and software tools for understanding large biological data sets.
    icon: science

  - name: Communication & Networking
    description: |
      Projects creating tools for communication, interoperability and distribution.
    icon: person

  - name: Cyber Security
    description: |
      Organizations working in computer security, cybersecurity, or information technology security.
    icon: security

  - name: Gaming / Entertainment
    description: |
      Organizations developing games, virtual environments, media and entertainment platforms.
    icon: laptop

  - name: Media Systems
    description: |
      Projects devoted to creating systems for communicative spaces.
    icon: book

  - name: Misc
    description: |
      Organizations developing games, virtual environments, media and entertainment platforms.
    icon: build

  - name: SaaS products
    description: |
      Projects dedicated to Internet based, licenced services
    icon: domain

  - name: Software Development
    icon: code
    description: |
      Organizations that provide software engineering services
---

<div class="top-sponsors top-sponsors--corporate">
  {%- for sponsor in site.data.sponsor_logos_corporate %}
    <a href="{{ sponsor.url }}" rel="nofollow sponsored">
      <img src="/assets/{{ sponsor.logo }}" alt="">
      {{- sponsor.name }}
    </a>
  {%- endfor %}
</div>

<hr />

<div class="used-in-production">
  {%- for section in page.sections %}
  <section>
    {%- assign icon = section.icon | prepend: 'icons/' | append: '.svg' %}
    {%- include elements/hex-icon.html file=icon %}

    <h3 id="{{ section.name | slugify }}">{{ section.name }}</h3>
    {{- section.description | markdownify }}

    {%- include pages/used_in_prod/companies.html section=section.name %}
  </section>
  {%- endfor %}
</div>

## Success stories

{% include components/posts-list.html posts=site.categories.success limit=3 %}

<div class="link-actions">
  <a href="/success-stories/">More success stories</a>
</div>
