---
title: Team
description: >
  Crystal is an open-source project based on the incredible efforts of a large
  community. Meet the people behind Crystal.
layout: page-wide
---

<section>
  <h2 id="core">Core Team</h2>
  <aside markdown="1">

The Core Team manages the development of Crystal and its ecosystem.
  </aside>

  <div class="cards-list">
    {% for member in site.data.team.core %}
      {% if member[1].status == "active" %}
        {% assign profile = member[1] %}
        {% include components/profile-card.html profile=profile slug=member.first %}
      {% endif %}
    {% endfor %}
  </div>
</section>

<section class="side-section">
  <h3 id="alumni">Alumni</h3>
  <aside markdown="1">
These awesome people have served as core team members in the past. They are listed here to record and honor their contributions.
  </aside>

  <div class="cards-list">
    {% for member in site.data.team.alumni %}
      <div class="profile-mini" itemscope itemtype="https://schema.org/Person">
        <img src="/assets/authors/{{ member[0] }}.jpg" alt="Profile picture of {{ member[1].name }}" />
        <span class="name" itemprop="name">{{ member[1].name }}</span>
        <a href="https://github.com/{{ member[1].github_handle | default: member[0] }}" itemprop="url" title="GitHub profile" class="ico github">@{{ member[1].github_handle | default: member[0] }}</a>
      </div>
    {% endfor %}
  </div>
</section>

<hr class="full">

<section class="side-section">
  <h2 id="admins">Admins</h2>
  <aside markdown="1">
Some people help with administrative duties, for example related to the management of assets and infrastructure, and communications. They have access to some resources and may participate as representatives of Crystal, but are not Core Team members. They do not take part in project decisions.
  </aside>

  <div class="cards-list">
    {% for member in site.data.team.admin %}
      {% assign profile = member[1] %}
      {% include components/profile-card.html profile=profile slug=member.first %}
    {% endfor %}
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
    {% for member in site.data.team.moderators %}
      {% assign profile = member[1] %}
      {% include components/profile-card.html profile=profile slug=member.first %}
    {% else %}
    <em>none</em>
    {% endfor %}
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

If you want to become a contributor, see our [Contributing Instructions](https://github.com/crystal-lang/crystal/blob/master/CONTRIBUTING.md) and [Code of Conduct](https://github.com/crystal-lang/crystal/blob/master/CODE_OF_CONDUCT.m).
  </aside>
  <div>
    <img src="https://opencollective.com/crystal-lang/contributors.svg?width=960">
  </div>
</section>

<section class="top-sponsors separator full">
  <a href="/sponsors/" class="hex border above">
    <span>Sponsors</span>
  </a>

  <p class="text-center grey-text">All this is only possible through our generous <a href="/sponsors/" class="black-text underline bold">sponsors</a> which help sustaining the project.</p>

  <ul class="grid x4">
    <li>
      <a href="https://manas.tech" target="_blank">
        <picture>
          <img src="/assets/sponsors/m.svg" alt="Manas.tech">
        </picture>
        <h2>Manas.tech</h2>
      </a>
    </li>
    <li>
      <a href="https://www.84codes.com" target="_blank">
        <picture>
          <img src="/assets/sponsors/84.svg" alt="84 codes">
        </picture>
        <h2>84 codes</h2>
      </a>
    </li>
    <li>
      <a href="https://nikolamotor.com/" target="_blank">
        <picture>
          <img src="/assets/sponsors/nikola.svg" alt="Nikola Motor Company">
        </picture>
        <h2>Nikola Motor Company</h2>
      </a>
    </li>
    <li>
      <a href="https://place.technology/" target="_blank">
        <picture>
          <img src="/assets/sponsors/placeos.svg" alt="PlaceOs">
        </picture>
        <h2>PlaceOs</h2>
      </a>
    </li>
  </ul>
</section>

<section class="grid x3 topics">

  <article>
    <h2 class="ico heart left">Sponsorship</h2>
    <p>Become a Crystal sponsor in only 3 simple steps via OpenCollective</p>
    <a href="#" target="_blank" class="hex btn shadow"><span>Contribute</span></a>
  </article>

  <article>
    <h2 class="ico building left">Enterprise support</h2>
    <p>Sponsoring Crystal creates a great springboard for your brand</p>
    <a href="#" target="_blank" class="hex btn shadow"><span>Get Support</span></a>
  </article>

  <article>
    <h2 class="ico shuttle left">Hire us for your project</h2>
    <p>You can tap into the expertise of the very creators of the language to guide you in your implementation. </p>
    <a href="#" target="_blank" class="hex btn shadow"><span>Hire Us</span></a>
  </article>

</section>

<section markdown="1" id="sponsors">
## Our sponsors

All this is only possible through our generous [sponsors](/sponsors)
which help sustaining the project.

Check out our sponsorship page at [OpenCollective](https://opencollective.com/crystal-lang) if you want to become one of them.

Corporate sponsors please reach out to [crystal@manas.tech](mailto:crystal@manas.tech). We're happy to work with you.
</section>

<section markdown="1" id="join">
## Join the team

If you want to become a contributors, see our [Contributing Instructions](https://github.com/crystal-lang/crystal/blob/master/CONTRIBUTING.md) and [Code of Conduct](https://github.com/crystal-lang/crystal/blob/master/CODE_OF_CONDUCT.md).

  Community members with a good understanding of the current processes and topics in the Crystal community, can be considered to be become a moderator.
  Respectable and helpful conduct is obviously required for that. If you think you qualify and want to apply, please don't hesitate to contact the core team at [crystal@manas.tech](mailto:crystal@manas.tech).
</section>