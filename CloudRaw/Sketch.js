function setup() {
  //frameRate = 120;
  
  setupBaseGenerator();
  generateBase();
  generateTarget();
  setupMosaic();
}

function draw() {
  updateMosaic();
  drawMosaic();
}

function generateTarget() {
  target = createCanvas(width, height);
  targetCtx = getContext(target);
  setupText(targetCtx);
  background(255, targetCtx);
  drawCenteredText(randomTranslation(), 750, targetCtx);
}

function regenerate() {
  generateBase();
  generateTarget();
  setupMosaic();
}
