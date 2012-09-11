function setup() {
  frameRate = .5;//60;
  setupBaseGenerator();
}

function draw() {
  generateBase();
  ctx.drawImage(base, 0, 0);
}
