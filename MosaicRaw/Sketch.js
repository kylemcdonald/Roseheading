var baseImage = new Image();
baseImage.src = "img/base.png";
var targetImage = new Image();
targetImage.src = "img/target.png";

function setup() {
  //frameRate = 10;//60;
  base = imageToCanvas(baseImage);
  target = imageToCanvas(targetImage);
  setupMosaic();
}

function draw() {
  trigger(pick(pw), pick(ph));
  
  updateMosaic();
  drawMosaic();
  ctx.drawImage(baseSmall, 0, 0);
  ctx.drawImage(targetSmall, pw, 0);
}
