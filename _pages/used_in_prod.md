---
title: Used in production
description: |
  Companies and individuals all over the world are using Crystal in production
  for projects of all kinds.
layout: page-wide
section: community
---

> **NOTE:**
> Fill [this short form](https://airtable.com/shrapvn1N02qwkowQ) to let us know that you are also using Crystal in production at your company or project, and we’ll add you to the list on the website.

<table class="table" id="sponsors-tbl">
  <thead>
    <th><span>Company / project</span></th>
    <th><span>Category</span></th>
    <th><span>Description</span></th>
  </thead>
  <tbody>
    {%- for uip in site.data.companies %}
    <tr>
      <td>
        {%- if uip.url %}
        <a href="{{uip.url}}" target="_blank" rel="sponsored nofollow">
          {{uip.name}}
        </a>
        {%- else %}
        {{uip.name}}
        {%- endif %}
      </td>
      <td>
        {{uip.category}}
      </td>
      <td>
        {{uip.description | markdownify}}
      </td>
    </tr>
    {%- endfor %}
  </tbody>
</table>

<script src="/assets/js/tablesort.js"></script>
<script>
  new Tablesort(document.getElementById('sponsors-tbl'));
</script>
