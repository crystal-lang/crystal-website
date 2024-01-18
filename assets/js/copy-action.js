/*document.querySelectorAll("pre").forEach(copy_action)*/

window.copy_action = function($elem) {
  $a = document.createElement("button")
  $a.classList.add("copy-action")
  $a.setAttribute("title", "Copy content")
  //$a.setAttribute("href", "#copy-action")
  $img = document.createElement("img")
  $img.setAttribute("alt", "Copy Content")
  $img.classList.add("icon")
  $img.setAttribute("src", "/assets/icons/copy-content.svg")
  $a.append($img)
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
