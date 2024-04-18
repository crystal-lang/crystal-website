const startLogoAnimation = function() {
  const canvas = document.getElementById("logo-canvas")
  var model = new Viewer3D(canvas);
  model.shader("flat", 255, 255, 255);
  model.insertModel("/assets/icosahedron.xml");
  model.contrast(0.90);
}

const setIPhoneDataAttribute = function() {
  let platform = navigator?.userAgent || navigator?.platform || 'unknown'

 if(/iPhone/.test(platform)) {
  document.documentElement.dataset.uaIphone = true;
 }
}

document.addEventListener("DOMContentLoaded", function() {
  setIPhoneDataAttribute()
  startLogoAnimation()
})
