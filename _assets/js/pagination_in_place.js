// This is not exactly sustainable through time. It'll be too heavy with the amount of posts growing.
// It's a compromise to fake pagination, because Jekyll won't allow filters to paginate,
// and it didn't seem like a good alternative to load articles one at a time.
// It might be more reasonable to just take the user to a new page.
function Paginator(list, initialCount, pageCount, button) {

  var postList = list.children(),
      postsToLoad = postList.length,
      loadedPosts = initialCount;

  // Hide all posts after the first 10
  postList.each(function(i) {
    if(i >= loadedPosts) {
      $(this).addClass("hidden");
    }
  })

  // "Load more" -> show next 5 hidden
  button.on("click", function(e){
    postList.filter(":hidden").each(function(i) {
      if(i < pageCount) {
        $(this).removeClass("hidden")
      }
      else {
        false
      }
    })
    loadedPosts += pageCount
    if(loadedPosts >= postsToLoad) $(this).addClass("hidden")
  })
}

$(function() {
  if($('.post-list').length > 0) {
    Paginator($('.post-list'), 5, 5, $('a#more-articles'))
    Paginator($('.notes-list'), 10, 5, $('a#more-notes'))
  }
});
