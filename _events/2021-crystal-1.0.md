---
title: Crystal 1.0 Conference
---

We are unbelievably proud to announce that, after years of hard work, we finally have a [1.0 version of Crystal!](/2021/03/22/crystal-1.0-what-to-expect/)

For a long, long time, it was accepted that programming languages couldn’t be simultaneously programmer-friendly and efficient. In 2011, we set out to prove that assumption was wrong. Crystal is the result of that experiment, and the source of much joy, fun and growth for everyone involved.

With thousands of contributions from people worldwide, it was finally possible to reach the level of maturity required for a 1.0 milestone.

And that calls for celebration!

The Crystal Conference will be livestreamed, to make sure that the entire global community that has formed around Crystal can attend.

<div class="container">
  <div class="conference-session-list">
    <header><h2>Programme</h2></header>
    <div class="conference-sessions-grid">
    {% for session in site.data.conference_talks %}
        {% if session["Start time"] != lastStartTime %}
        <div class="conference-slot-info">
          <time class="local-time" datetime="2021-07-08T{{ session["Start time"] }}+00:00" title="2021-07-08 {{ session["Start time"] }} UTC">{{ session["Start time"] }}</time>
        </div>
        {% endif %}
        {% assign lastStartTime = session["Start time"] %}
        {% assign lastEndTime = session["End time"] %}
        {% if session["Session type"] == "Long Break" or session["Session type"] == "Setup" %}
            {% assign parts = session["Name"] | split: '-' %}
            {% assign break_desc = parts | slice: 1, 1000 %}
            <div class="conference-sessions-break">{{break_desc | join: '-'}}</div>
          {% else %}
          <div class="conference-session conference-session--{{ session['Room'] | slugify }} conference-session--span{{ session['Row span'] | default: 1 }}">
              <div class="presenter">
                {% if session["Speaker picture"] %}
                  {% assign parts = session["Speaker picture"] | split: ' (' %}
                  {% assign parts = parts[1] | split: ')' %}
                  <div class="speaker-image" style="background-image: url('{{ parts[0] }}')"></div>
                {% endif %}
                <div>
                  <div>{{ session["Presenter"] }}</div>
                    {% if session["Link"] %}
                      <p class="session-link">
                        <a href="https://github.com/{{ session["Link"] }}">@{{ session["Link"] }}</a>
                      </p>
                    {% endif %}
                </div>
              </div>
              <h3>{{ session["Talk title"] }}</h3>

              {% if session["Theme"] %}
                <div class="icon-prefix">
                  {% include icons/label.svg %}
                  {{ session["Theme"] }}
                </div>
              {% endif %}
              <div class="icon-prefix">
                {% include icons/schedule.svg %}
                {{ session["Duration (minutes)"] }} minutes at {{ session["Room" ] }}
              </div>
              <p class="session-links">
                {% if session["Video Link"] %}
                  <div class="link-item">
                    <a href="{{ session["Video Link"] }}">
                      {% include icons/videocam.svg %}
                      Recording
                    </a>
                  </div>
                {% endif %}
                {% if session["Slides Link"] %}
                  <div class="link-item">
                    <a href="{{ session["Slides Link"] }}">
                      {% include icons/slideshow.svg %}
                      Slides
                    </a>
                  </div>
                {% endif %}
              </p>

              {% if session["Abstract"] %}
                <p class="session-summary">
                  {{ session["Abstract"] }}
                </p>
              {% endif %}
          </div>
          {% endif %}
        {% endfor %}
      </div>
  </div>
</div>

<script>

document.addEventListener("DOMContentLoaded", function() {
  var locale = "default";
  var options = {
    weekday: 'long', year: 'numeric', month: 'long', day: 'numeric',
    hour: 'numeric', minute: 'numeric', timeZoneName: 'short'};
  var titleFormat = new Intl.DateTimeFormat(locale, options);
  var textFormat = new Intl.DateTimeFormat(locale, {hour: "numeric", minute: "numeric"});

  document.querySelector("h2").innerHTML += ` <small>(times are displayed for ${textFormat.resolvedOptions().timeZone})</small>`

  document.querySelectorAll("time.local-time").forEach(function(elem){
    var date = new Date(elem.dateTime);
    var timezone = date.getTimezoneOffset() / -60
    elem.innerHTML = textFormat.format(date) + `<small>UTC${!timezone? `` : timezone > 0? `+${timezone}` : timezone}</small>`;
    elem.title = titleFormat.format(date);
  })
})
document.addEventListener('scroll', () => {
  const header = document.querySelector("header")
  header.classList.toggle('shadow', header.getBoundingClientRect().y === 0)
})

</script>

### Time

The conference took place on Thursday, 8 July 2021, from 12:30 pm to 9:30 pm UTC.

## Code of Conduct

### Purpose

At the Crystal 1.0 Conference, we aim to be inclusive to the largest number of participants, with the most varied and diverse backgrounds possible. As such, we are committed to providing a friendly, safe and welcoming environment for all, regardless of gender, sexual orientation, ability, ethnicity, socioeconomic status, and religion (or lack thereof).
We invite all those who participate in the Crystal 1.0 Conference to help us create safe and positive experiences for everyone.

### Expected behavior

Intentional, positive action is essential to avoid replicating within our conference community the many forms of inequality that exist in greater society. For this reason, we outline in this Code of Conduct expected behaviour as well as prohibited behavior.
The following behaviors are expected and requested of all participants:

* Participate in an authentic and active way. In doing so, you contribute to the health and longevity of this conference community.
* Exercise consideration and respect in your speech and actions.
* Attempt collaboration before conflict.
* Refrain from demeaning, discriminatory, or harassing behavior and speech.
* Be mindful of your fellow participants.

### Unacceptable behavior

The following behaviors are considered harassment and are unacceptable within our conference community:

* Violence, threats of violence and incitement of violence towards any individual.
* Derogatory comments related to gender, gender identity and expression, sexual orientation, disability, mental illness, neuro(a)typicality, physical appearance, body size, race, religion, or socio-economic status.
* Gratuitous or off-topic sexual images or behavior, sexualised comments or jokes.
* Posting or threatening to post other people’s personally identifying information (“doxing”).
* Deliberate misgendering or use of “dead” or rejected names.
* Inappropriate photography or recording.
* Deliberate intimidation or stalking.
* Sustained disruption of talks and presentations.
* Advocating for, or encouraging, any of the above behavior.

### Consequences of unacceptable behavior

Unacceptable behavior from any conference attendees, including speakers, will not be tolerated.
Anyone asked to stop unacceptable behavior is expected to comply immediately.
If a conference attendee or speaker engages in unacceptable behavior, the conference organisers may take any action they deem appropriate, up to and including a temporary ban or permanent expulsion from the conference without warning.

### Reporting guidelines

If you are subject to or witness unacceptable behavior, or have any other concerns, please notify the organiser as soon as possible by messaging [@CrystalLanguage](https://twitter.com/CrystalLanguage) in private, on Twitter, or reaching out to [crystal@manas.tech](mailto:crystal@manas.tech)
If you feel you have been falsely or unfairly accused of violating this Code of Conduct, you should notify the organiser as soon as possible by messaging [@CrystalLanguage](https://twitter.com/CrystalLanguage) in private, on Twitter, or reaching out to [crystal@manas.tech](mailto:crystal@manas.tech), with a concise description of your grievance.

### Scope

We expect all conference participants to abide by this Code of Conduct in all conference online venues, e.g. chat, breakout rooms, as well as in all one-on-one communications pertaining to the Crystal 1.0 Conference.

### Attribution

This Code of Conduct was adapted from the [#causeascene CoC](https://hashtagcauseascene.com/code-of-conduct/).
