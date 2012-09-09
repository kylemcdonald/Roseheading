var canvas, ctx;
var width, height;
var interval;
var frameRate = 30, frameCount = 0;

function init() {
  canvas = document.getElementById("Mosaic");
  ctx = canvas.getContext("2d");
  width = canvas.width, height = canvas.height;
  setup();
  interval = setInterval(
    function() {
      draw();
      frameCount++
    }, 1000 / frameRate);
}

function print(msg) {
  document.getElementById("debug").innerHTML = msg;
}

// - - --

var base, target;
var baseSmall, targetSmall;
var screenImageData;
var baseCanvas, baseContext, baseImageData;
var positions;
var pw, ph, pn, pieceSize = 10;

var stats;
function setupStats() {
  stats = new Stats();
  stats.setMode(0);
  stats.domElement.style.position = 'absolute';
  stats.domElement.style.left = '0px';
  stats.domElement.style.top = '0px';
  document.body.appendChild(stats.domElement);
}

function setup() {
  frameRate = 60;
  pw = Math.floor(width / pieceSize);
  ph = Math.floor(height / pieceSize);
  pn = pw * ph;
  
  base = new Image(), base.src = "img/base.png";
  baseSmall = copy(base, pw, ph);

  target = new Image(), target.src = "img/target.png";
  targetSmall = copy(target, pw, ph);
  
  positions = findMosaic(baseSmall, targetSmall);
  
  screenImageData = ctx.createImageData(width, height);
  baseCanvas = copy(base, width, height);
  baseContext = baseCanvas.getContext('2d');
  baseImageData = baseContext.getImageData(0, 0, width, height);
  
  setupStats();
}

function draw() {
  stats.begin();
  
  for(i = 0; i < 10; i++) {
    left = Math.floor(Math.random() * pn);
    right = Math.floor(Math.random() * pn);
    swap = positions[left];
    positions[left] = positions[right];
    positions[right] = swap;
  }
  
  sw = Math.floor(width / pw);
  sh = Math.floor(height / ph);
  pi = 0;
  src = baseImageData.data;
  dst = screenImageData.data;
  stepSize = 4 * (width - sw);
  for (py = 0; py < ph; ++py) {
    for (px = 0; px < pw; ++px) {
      cur = positions[pi];
      cy = Math.floor(cur / pw);
      cx = cur - (cy * pw);
      sx = cx * sw, sy = cy * sh;
      dx = px * sw, dy = py * sh;
      
      // copy sw x sh pixels
      si = 4 * (sy * width + sx);
      di = 4 * (dy * width + dx);
      for(yy = 0; yy < sh; ++yy) {
        for(xx = 0; xx < sw; ++xx) {
          dst[di] = src[si];
          dst[di+1] = src[si+1];
          dst[di+2] = src[si+2];
          dst[di+3] = 255;
          di += 4, si += 4;
        }
        si += stepSize;
        di += stepSize;
      }
      
      pi++;
    }
  }
  ctx.putImageData(screenImageData, 0, 0);
  stats.end();
}

function copy(mom, width, height) {
  buffer = document.createElement('canvas');
  buffer.width = width, buffer.height = height;
  buffer.getContext('2d').drawImage(mom, 0, 0, width, height);
  return buffer;
}

function lightness(src, i) {
  i *= 4;
  return Math.floor((src[i] + src[i+1] + src[i+2]) / 3);
}

function flatten(nested) {
  flat = new Array();
  for(i = 0; i < nested.length; i++) {
    for(j = 0; j < nested[i].length; j++) {
      flat.push(nested[i][j]);
    }
  }
  return flat;
}

function sortLightness(a, b) {
  return a.lightness - b.lightness;
}

var binnedSorting = false;
function findMosaic(src, dst) {
  positions = new Array(pn);
  
  srcData = src.getContext('2d').getImageData(0, 0, pw, ph).data;
  dstData = dst.getContext('2d').getImageData(0, 0, pw, ph).data;
  
  if(binnedSorting) {
    binCount = 256;
    srcBins = new Array(binCount);
    dstBins = new Array(binCount);
    for (i = 0; i < binCount; i++) {
      srcBins[i] = new Array();
      dstBins[i] = new Array();
    }
    j = 0;
    for (i = 0; i < pn; i++) {
      srcBins[lightness(srcData, i)].push(i);
      dstBins[lightness(dstData, i)].push(i);
    }
    flatSrc = flatten(srcBins);
    flatDst = flatten(dstBins);
    for (i = 0; i < pn; i++) {
      positions[flatDst[i]] = flatSrc[i];
    }
  } else {
    srcPairs = new Array(pn);
    dstPairs = new Array(pn);
    for(i = 0; i < pn; i++) {
      srcPairs[i] = {index: i, lightness: lightness(srcData, i)};
      dstPairs[i] = {index: i, lightness: lightness(dstData, i)};
    }
    srcPairs.sort(sortLightness);
    dstPairs.sort(sortLightness);
    for (i = 0; i < pn; i++) {
      positions[dstPairs[i].index] = srcPairs[i].index;
    }
  }
  
  return positions;
}
