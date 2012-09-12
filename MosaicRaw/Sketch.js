var baseImage = new Image();
baseImage.src = "data/base.png";

var targetImage = new Image();
targetImage.src = "data/target.png";

function setup() {
  //frameRate = 120;
  base = imageToCanvas(baseImage);
  target = imageToCanvas(targetImage);  
  setupMosaic();
  showStats = true;
}

function draw() {  
  updateMosaic();
  drawMosaic();
  ctx.drawImage(baseSmall, 0, 0);
  ctx.drawImage(targetSmall, pw, 0);
}
