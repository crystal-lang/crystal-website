//= require materialize.min
//= require viewer
//= require main
//= require pagination_in_place


$( document ).ready(function(){
  $(".button-collapse").sideNav();
})

$(document).on('click', 'a', function(event){
  event.preventDefault();
  $('html, body').animate({
      scrollTop: $( $.attr(this, 'href') ).offset().top - 100
  }, 500);
});

$(document).scroll(function(e){
    var scrollTop = $(document).scrollTop();
    if(scrollTop > 620){
        //console.log(scrollTop);
        $('.wrapper.main').addClass("fixed");
    } else {
        $('.wrapper.main').removeClass("fixed");
    }
});