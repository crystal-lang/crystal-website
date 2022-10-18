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

// $(document).on("click", ".play", async function(e) {
//   e.preventDefault();
//   var code = $(this).prev("code, figure").text();
//
//   var payload = {
//     "run_request": {
//       "code": $(this).prev("code, figure").text(),
//       "language": "crystal"
//     }
//   }
//
//   await fetch("https://carc.in/run_requests",
//   {
//       method: "POST",
//       headers: {
//         'Content-Type': 'application/json',
//       },
//       body: JSON.stringify( payload )
//   }, 50000)
//   .then(function(res){ return res.json(); })
//   .then(function(data){ alert( JSON.stringify( data ) ) })
//
// });


// $(function(){
//   $(".code_section.run").each(function(i){
//     $(this).append('<svg class="play" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 73.72 29.15"><rect class="play1" x=".7" y=".7" width="72.32" height="27.75" rx="2" ry="2"/><polygon class="play2" points="23.8 15.65 16.54 9.7 16.54 21.19 23.8 15.65"/><text class="play3" transform="translate(31.88 19.11)"><tspan x="0" y="0">Run</tspan></text></svg>');
//   });
// });
