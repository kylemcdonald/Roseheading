function setup() {
  //frameRate = 120;
  showStats = true;
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

function beginRewind() {
  generateBase();
  updateAltImageData();
}

function endRewind() {
  generateTarget();
  setupMosaic();
}

function fullscreenChange() {
/*
  if(fullscreen) {
    canvas.width = document.width;
    canvas.height = document.height;
  } else {
    canvas.width = 950;
    canvas.height = 540;
  }
  // need to reallocate screenImageData
  */
}