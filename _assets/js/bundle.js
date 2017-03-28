//= require materialize.min
//= require viewer
//= require delaunay
//= require main
//= require pagination_in_place
//= require web_server_benchmark


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
