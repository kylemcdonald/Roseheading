function setup() {
  //frameRate = 60;
  setupMosaic();
}

function draw() {
  drawMosaic();
  ctx.drawImage(baseSmall, 0, 0);
  ctx.drawImage(targetSmall, pw, 0); 
}
