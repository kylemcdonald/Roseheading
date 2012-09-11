function setup() {
  frameRate = .5;//60;
  setupBaseGenerator();
  setupMosaic();
  generateBase();
}

function draw() {
  drawMosaic();
}
