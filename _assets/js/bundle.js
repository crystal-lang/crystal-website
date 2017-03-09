//= require materialize.min
//= require viewer
//= require main
//= require pagination_in_place


$( document ).ready(function(){
  $('.button-collapse').sideNav({
      closeOnClick: true
    }
  );
});

$(document).on('click', 'a', function(event){
  $('html, body').animate({
      scrollTop: $( $.attr(this, 'href') ).offset().top - 100
  }, 500);
});

$(document).scroll(function(e){
    var scrollTop = $(document).scrollTop();
    if(scrollTop > 616){
        $('.wrapper.main').addClass("fixed");
    } else {
        $('.wrapper.main').removeClass("fixed");
    }
});