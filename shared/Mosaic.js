var base, target;
var baseSmall, targetSmall;
var screenImageData;
var baseCanvas, baseImageData;
var positions, states;
var pw, ph, pn, pieceSize = 10;
var moveRadius = 16;
var moveTime = 2000;

var piecePositions;

function setupMosaic() {
  pw = floor(width / pieceSize);
  ph = floor(height / pieceSize);
  pn = pw * ph;
  
  baseSmall = resizeArea(base, pw, ph);
  targetSmall = resizeArea(target, pw, ph);
  
  positions = findMosaic(baseSmall, targetSmall);
  states = new Array(pn);
  for(i = 0; i < pn; i++) {
    states[i] = 0;
  }
  piecePositions = new Array(pn);
  
  screenImageData = ctx.createImageData(width, height);
  baseCanvas = imageToCanvas(base);
  baseImageData = getImageData(baseCanvas);
}

function drawMosaic() {
  sw = floor(width / pw);
  sh = floor(height / ph);
  pi = 0;
  src = baseImageData.data;
  dst = screenImageData.data;
  stepSize = 4 * (width - sw);
  
  var curDst, sx, sy, dx, dy, si, di, xx, yy;
  for (py = 0; py < ph; py++) {
    for (px = 0; px < pw; px++) {
      curDst = piecePositions[pi];
      
      sx = px * sw, sy = py * sh;
      dx = curDst.x, dy = curDst.y;
      
      // copy sw x sh pixels
      si = 4 * (sy * width + sx);
      di = 4 * (dy * width + dx);
      for(yy = 0; yy < sh; yy++) {
        for(xx = 0; xx < sw; xx++) {
          dst[di++] = src[si++];
          dst[di++] = src[si++];
          dst[di++] = src[si++];
          dst[di++] = 255; si++;
        }
        si += stepSize;
        di += stepSize;
      }
      
      pi++;
    }
  }
  ctx.putImageData(screenImageData, 0, 0);
}

// resize one canvas into another using area averaging
function resizeArea(src, dw, dh) {
  sw = src.width, sh = src.height;
  w = floor(sw / dw), h = floor(sh / dh);
  dstCanvas = createCanvas(dw, dh);
  srcImageData = getImageData(src);
  dstImageData = dstCanvas.getContext('2d').createImageData(dw, dh);
  srcData = srcImageData.data;
  dstData = dstImageData.data;
  i = 0;
  n = w * h;
  var x, y, j, stepSize, xx, yy;
  sum = new Array(3);
  for(y = 0; y < dh; y++) {
    for(x = 0; x < dw; x++) {
      sum[0] = 0, sum[1] = 0, sum[2] = 0;
      j = 4 * ((y * h * sw) + (x * w));
      stepSize = 4 * (sw - w);
      for(yy = 0; yy < h; yy++) {
        for(xx = 0; xx < w; xx++) {
          sum[0] += srcData[j++];
          sum[1] += srcData[j++];
          sum[2] += srcData[j++];
          j++;
        }
        j += stepSize;
      }      
      dstData[i] = sum[0] / n;
      dstData[i+1] = sum[1] / n;
      dstData[i+2] = sum[2] / n;
      dstData[i+3] = 255;
      i += 4;
    }
  }
  dstCanvas.getContext('2d').putImageData(dstImageData, 0, 0);
  return dstCanvas;
}  

function getLightness(src, i) {
  i *= 4;
  return (src[i] + src[i+1] + src[i+2]) / 3;
}

function flatten(nested) {
  flat = new Array();
  for(i = 0; i < nested.length; ++i) {
    for(j = 0; j < nested[i].length; ++j) {
      flat.push(nested[i][j]);
    }
  }
  return flat;
}

function findMosaic(src, dst) {
  positions = new Array(pn);
  srcData = getImageData(src).data;
  dstData = getImageData(dst).data;
  binCount = 256;
  srcBins = new Array(binCount);
  dstBins = new Array(binCount);
  for (i = 0; i < binCount; ++i) {
    srcBins[i] = new Array();
    dstBins[i] = new Array();
  }
  for (i = 0; i < pn; ++i) {
    srcBins[getLightness(srcData, i)|0].push(i);
    dstBins[getLightness(dstData, i)|0].push(i);
  }
  flatSrc = flatten(srcBins);
  flatDst = flatten(dstBins);
  for (i = 0; i < pn; ++i) {
    positions[flatSrc[i]] = flatDst[i];
  }  
  return positions;
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

function updateMosaic() {
  var w = width, h = height;
  var sw = floor(w / pw), sh = floor(h / ph);
  var curTime = millis();
  var k = 0, n = pw * ph;
  
  var x, y, cur, cy, cx, sx, sy, tx, ty, ax, ay;
  var timeDiff, state, dx, dy;
  
  for (y = 0; y < ph; y++) {
    for (x = 0; x < pw; x++) {
      cur = positions[k];
      cy = floor(cur / pw), cx = cur - (cy * pw);
      
      sx = x * sw, sy = y * sh;
      tx = cx * sw, ty = cy * sh;
      timeDiff = constrain(curTime - states[k], 0, moveTime);
      state = states[k] == 0 ? 0 : constrain(timeDiff / moveTime, 0, 1);
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
}
