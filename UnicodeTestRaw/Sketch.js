function setup() {
  frameRate = 2;
  setupText();
}

function draw() {
  background(255);
  drawCenteredText(randomTranslation(), 750);
}