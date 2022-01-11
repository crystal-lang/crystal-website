---
layout: none
---

{% include_relative _materialize.min.js %}
{% include_relative _viewer.js %}
{% include_relative _delaunay.js %}
{% include_relative _main.js %}
{% include_relative _pagination_in_place.js %}

$( document ).ready(function(){
  $('.button-collapse').sideNav({
      closeOnClick: true
    }
  );

  $("#nav-mobile a").click(function(e) {
    e.preventDefault();
    $("#nav-mobile, #sidenav-overlay, .drag-target").remove();
    window.setTimeout(function() {
      window.location = $(e.target).attr("href");
    }, 0);
  });
});
