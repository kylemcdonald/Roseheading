function setup() {
  frameRate = 2;//60;
  setupBaseGenerator();
}

function draw() {
  generateBase();
  ctx.drawImage(base, 0, 0);
}
