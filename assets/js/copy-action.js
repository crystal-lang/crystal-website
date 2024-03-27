window.copy_action = function($elem) {
  $a = document.createElement("button")
  $a.classList.add("copy-action")
  $a.setAttribute("title", "Copy content")
  $label = document.createElement("div")
  $label.setAttribute("alt", "Copy Content")
  $label.classList.add("visually-hidden")
  $a.append($label)
  $elem.append($a)

  $a.addEventListener("click", function(event){
    console.log($elem);
    navigator.clipboard.writeText($elem.firstChild.textContent);
    $elem.classList.add("copied")
    setTimeout(function(){
      $elem.classList.remove("copied");
    }, 1000);
    return false;
  })
};
