---
tile: Used in production
---
<style>
  .top {
    padding: 0px 0 60px;
    font-size: 14px;
  }

  .top a {
      display: inline-block;
      text-align: center;
   }

  .top a picture {
        height: 140px;
        width: 100%;
        display: flex;
        justify-content: center;
        align-items: center;
      }
  .top a img {
        filter: invert(0%) sepia(95%) saturate(21%) hue-rotate(2deg) brightness(0%) contrast(107%);
        width: 78px;
        height: auto;
        transition: filter .3s;
  }

  .top a img.h {
          width: 120px;
        }

  .top a:hover img {
      filter: none;
  }
</style>
<section>
  <h2>Used in production</h2>

  <p>Companies and individuals all over the world are using Crystal in production for projects of all kinds.</p>
  <section class="grid x6 top">
    {% for company in site.data.used_in_production %}
    <a href="{{company.url}}" target="_blank">
      <picture>
        <img src="/assets/sponsors/{{company.image}}" alt="{{company.name}}"{% if company.class %} class="{{company.class}}"{% endif %}>
      </picture>
      {{company.name}}
    </a>
    {% endfor %}
  </section>
  <a class="hex btn shadow" href="/used_in_prod" style="white-space: nowrap; width: min-content; margin: auto;"><span style="padding: 0 3em;">Learn more</span></a>
</section>
