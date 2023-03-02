document.addEventListener("DOMContentLoaded", function() {
  const canvas = document.getElementById("logo-canvas")
  var model = new Viewer3D(canvas);
  model.shader("flat", 255, 255, 255);
  model.insertModel("/assets/icosahedron.xml");
  model.contrast(0.90);
})
