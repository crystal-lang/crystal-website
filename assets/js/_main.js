var canvas = document.getElementById("logo-canvas")
var model = new Viewer3D(canvas);
model.shader("flat", 255, 255, 255);
model.insertModel("/assets/icosahedron.xml");
model.contrast(0.90);

var addTooltip = function ( copyBtn ) {
  if( copyBtn.find(".tooltip").length == 0 ) {
    copyBtn.append('<div class="tooltip ttimer2"><i class="icon-tick"></i> Copied</div>');
    var timer = setTimeout( function() {
      copyBtn.find(".tooltip").remove();
    }, 2000 );
  }
}

$(document).on("click", "[data-copy]", function(e) {
  e.preventDefault();

  navigator.clipboard.writeText(window.location.href)
  var copy = $(this);

  addTooltip(copy);
  return false;
});


// $(document).on("click", "code", function(e) {
//   e.preventDefault();
//
//   var copyBtn = $(this);
//   var selection = window.getSelection();
//
//   selection.selectAllChildren(this);
//   document.execCommand("copy");
//   selection.removeAllRanges();
//
//   addTooltip(copyBtn)
//
//   return false;
//
// });
