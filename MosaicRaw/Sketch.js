var baseImage = new Image();
baseImage.src = "img/base.png";
var targetImage = new Image();
targetImage.src = "img/target.png";

var moveRadius = 16; // blocks
var moveTime = 2000;

function setup() {
  //frameRate = 10;//60;
  base = imageToCanvas(baseImage);
  target = imageToCanvas(targetImage);
  setupMosaic();
}

function draw() {
  drawMosaic();
  ctx.drawImage(baseSmall, 0, 0);
  ctx.drawImage(targetSmall, pw, 0);
}

function trigger(x, y) {
  var i = y * pw + x;
  if (states[i] == 0) {
    states[i] = millis();
  }
}

function mouseMoved() {
  var x = mouseX / pieceSize, y = mouseY / pieceSize;
  if (x >= 0 && y >= 0 && x < pw && y < ph) {
    for (i = 0; i < pw; i++) {
      for (j = 0; j < ph; j++) {
        if (dist(i, j, x, y) < moveRadius * random(.1, 1)) {
          trigger(i, j);
        }
      }
    }
  }
}

// this is slow
function getPiecePositions() {
  var w = width, h = height;
  var sw = floor(w / pw), sh = floor(h / ph);
  var curTime = millis();
  var k = 0, n = pw * ph;
  
  var x, y, cur, cy, cx, sx, sy, tx, ty, ax, ay;
  var timeDiff, state, dx, dy;
  
  var piecePositions = new Array(n);
  for (y = 0; y < ph; y++) {
    for (x = 0; x < pw; x++) {
      cur = positions[k];
      cy = floor(cur / pw), cx = cur - (cy * pw);
      
      sx = x * sw, sy = y * sh;
      tx = cx * sw, ty = cy * sh;
      timeDiff = constrain(curTime - states[cur], 0, moveTime);
      state = states[cur] == 0 ? 0 : constrain(timeDiff / moveTime, 0, 1);
      state = smoothStep(state);
      dx = floor(abs(tx - sx)), dy = floor(abs(ty - sy));
      state *= (dx + dy);
      if (dx > dy) {
        ax = floor(dx == 0 ? tx : lerp(sx, tx, constrain(state, 0, dx) / dx));
        ay = floor(dy == 0 ? ty : lerp(sy, ty, constrain(state - dx, 0, dy) / dy));
      } 
      else {
        ax = floor(dx == 0 ? tx : lerp(sx, tx, constrain(state - dy, 0, dx) / dx));
        ay = floor(dy == 0 ? ty : lerp(sy, ty, constrain(state, 0, dy) / dy));
      }
      piecePositions[k] = {x:ax, y:ay};
      k++;
    }
  }
  return piecePositions;
}