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
  baseSmall = createResized(base, pw, ph);

  target = new Image(), target.src = "img/target.png";
  targetSmall = createResized(target, pw, ph);

  positions = findMosaic(baseSmall, targetSmall);
  
  setupStats();
}

function draw() {
  stats.begin();
  sw = Math.floor(width / pw);
  sh = Math.floor(height / ph);
  i = 0;
  for (y = 0; y < ph; y++) {
    for (x = 0; x < pw; x++) {
      cur = positions[i];
      cy = Math.floor(cur / pw);
      cx = cur - (cy * pw);
      sx = cx * sw, sy = cy * sh;
      tx = x * sw, ty = y * sh;
      ctx.drawImage(base, sx, sy, sw, sh, tx, ty, sw, sh);
      i++;
    }
  }
  stats.end();
}

function createResized(from, width, height) {
  buffer = document.createElement('canvas');
  buffer.width = width, buffer.height = height;
  buffer.getContext('2d').drawImage(from, 0, 0, width, height);
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
