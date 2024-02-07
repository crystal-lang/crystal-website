---
title: Team
description: >
  Crystal is an open-source project based on the incredible efforts of a large
  community. Meet the people behind Crystal.
layout: page-wide
section: community
---

<section>
  <h2 id="core">Core Team</h2>
  <aside markdown="1">

The *Core Team* leads the development of Crystal and its ecosystem under the
guidance of the *Steering Council*. Both bodies are defined in the
[Governance document](/_pages/community/governance.md).

  </aside>

  <div class="cards-list">
    {%- for member in site.data.team.core %}
      {%- if member[1].status == "active" %}
        {%- assign profile = member[1] %}
        {%- include components/profile-card.html profile=profile slug=member.first %}
      {%- endif %}
    {%- endfor %}
  </div>
</section>

<section class="side-section">
  <h3 id="alumni">Alumni</h3>
  <aside markdown="1">
These awesome people have served as core team members in the past. They are listed here to record and honor their contributions.
  </aside>

  <div class="cards-list">
    {%- for member in site.data.team.alumni %}
      <div class="profile-mini" itemscope itemtype="https://schema.org/Person">
        <img src="/assets/authors/{{ member[0] }}.jpg" alt="Profile picture of {{ member[1].name }}" />
        <span class="name" itemprop="name">{{ member[1].name }}</span>
        <a href="https://github.com/{{ member[1].github_handle | default: member[0] }}" itemprop="url" title="GitHub profile" class="ico github">@{{ member[1].github_handle | default: member[0] }}</a>
      </div>
    {%- endfor %}
  </div>
</section>

<hr class="full">

<section class="side-section">
  <h2 id="admins">Admins</h2>
  <aside markdown="1">
Some people help with administrative duties, for example related to the management of assets and infrastructure, and communications. They have access to some resources and may participate as representatives of Crystal, but are not Core Team members. They do not take part in project decisions.
  </aside>

  <div class="cards-list">
    {%- for member in site.data.team.admin %}
      {%- assign profile = member[1] %}
      {%- include components/profile-card.html profile=profile slug=member.first %}
    {%- endfor %}
  </div>
</section>

<section class="side-section">
  <h2 id="admin-alumni">Admin Alumni</h2>

  <aside markdown="1">
These awesome people have been part of the team in the past but do no longer fill that role.
  </aside>

  <div class="cards-list">
    {%- for member in site.data.team.admin_alumni %}
      <div class="profile-mini" itemscope itemtype="https://schema.org/Person">
        <img src="/assets/authors/{{ member[0] }}.jpg" alt="Profile picture of {{ member[1].name }}" />
          {%- if member[1].role %}
            <span class="member_role">{{ member[1].role }}</span>
          {%- endif %}
        <span class="name" itemprop="name">{{ member[1].name }}</span>
        <a href="https://github.com/{{ member[1].github_handle | default: member[0] }}" itemprop="url" title="GitHub profile" class="ico github">@{{ member[1].github_handle | default: member[0] }}</a>
      </div>
    {%- endfor %}
  </div>
</section>

<hr class="full">

<section class="side-section">
  <h2 id="moderators">Community Moderators</h2>
  <aside id="join_us" markdown="1">

Some experienced members of the community help moderating the community channels.
They have the [Triage role](https://docs.github.com/en/organizations/managing-access-to-your-organizations-repositories/repository-permission-levels-for-an-organization)
on GitHub which gives them the ability to assign labels, open & close issues/PRs, apply milestones, mark duplicates,
assign issues/PRs and request reviews.
  </aside>

  <div class="cards-list">
    {%- for member in site.data.team.moderators %}
      {%- assign profile = member[1] %}
      {%- include components/profile-card.html profile=profile slug=member.first %}
    {%- else %}
    <em>none</em>
    {%- endfor %}
  </div>
</section>

<section class="bg-gray">
  <p class="ico heart-black left">
  </p>
</section>

> **NOTE:**
> Community members with a good understanding of the processes and topics in the community are eligible to become moderators. If you would like to apply, please contact the core team at [crystal@manas.tech](mailto:crystal@manas.tech).

<hr class="full">

<section class="side-section">
  <h2 id="contributors">Contributors</h2>
  <aside markdown="1">
Besides those that are explicitly named, this is a call out to
[hundreds more contributors](https://github.com/crystal-lang/crystal/graphs/contributors)
who put their work into the project.

If you want to become a contributor, see our [Contributing Instructions](https://github.com/crystal-lang/crystal/blob/master/CONTRIBUTING.md) and [Code of Conduct](https://github.com/crystal-lang/crystal/blob/master/CODE_OF_CONDUCT.md).
  </aside>
  <div>
    <img src="https://opencollective.com/crystal-lang/contributors.svg?width=960" alt="">
  </div>
</section>

{% include components/top-sponsors.html %}

{% include components/sponsorship.html %}
