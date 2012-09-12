function setup() {
  //frameRate = 120;
  
  setupBaseGenerator();
  generateBase();
  
  target = createCanvas(width, height);
  targetCtx = getContext(target);
  setupText(targetCtx);
  background(255, targetCtx);
  drawCenteredText(randomTranslation(), 750, targetCtx);
  
  setupMosaic();
}

function draw() {
  trigger(pick(pw), pick(ph));
  
  updateMosaic();
  drawMosaic();
  //ctx.drawImage(baseSmall, 0, 0);
  //ctx.drawImage(targetSmall, pw, 0);
}
