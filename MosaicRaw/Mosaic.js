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

var positions, states;
var pw, ph, pn, pieceSize = 10;

function setup() {
  frameRate = 30;
  pw = Math.floor(width / pieceSize);
  ph = Math.floor(height / pieceSize);
  pn = pw * ph;
  
  base = new Image(), base.src = "img/base.png";
  baseSmall = createResized(base, pw, ph);

  target = new Image(), target.src = "img/target.png";
  targetSmall = createResized(target, pw, ph);

  positions = findMosaic(baseSmall, targetSmall);
  //states = new int[positions.length];
}

function draw() {
  ctx.drawImage(baseSmall, 0, 0);
  ctx.drawImage(targetSmall, pw, 0);
}

function createResized(from, width, height) {
  var buffer = document.createElement('canvas');
  buffer.width = width, buffer.height = height;
  buffer.getContext('2d').drawImage(from, 0, 0, width, height);
  return buffer;
}

function lightness(src, i) {
  i *= 4;
  return Math.floor((src[i] + src[i+1] + src[i+2]) / 3);
}

function flatten(nested) {
  var flat = new Array();
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
  var positions = new Array(pn);
  
  var srcData = src.getContext('2d').getImageData(0, 0, pw, ph).data;
  var dstData = dst.getContext('2d').getImageData(0, 0, pw, ph).data;
  
  if(binnedSorting) {
    var binCount = 256;
    var srcBins = new Array(binCount);
    var dstBins = new Array(binCount);
    for (var i = 0; i < binCount; i++) {
      srcBins[i] = new Array();
      dstBins[i] = new Array();
    }
    var msg = "";
    var j = 0;
    for (var i = 0; i < pn; i++) {
      srcBins[lightness(srcData, i)].push(i);
      dstBins[lightness(dstData, i)].push(i);
    }
    var flatSrc = flatten(srcBins);
    var flatDst = flatten(dstBins);
    for (var i = 0; i < pn; i++) {
      positions[flatDst[i]] = flatSrc[i];
    }
  } else {
    var srcPairs = new Array(pn);
    var dstPairs = new Array(pn);
    for(i = 0; i < pn; i++) {
      srcPairs[i] = {index: i, lightness: lightness(srcData, i)};
      dstPairs[i] = {index: i, lightness: lightness(dstData, i)};
    }
    srcPairs.sort(sortLightness);
    dstPairs.sort(sortLightness);
    for (var i = 0; i < pn; i++) {
      positions[dstPairs[i].index] = srcPairs[i].index;
    }
  }
  
  return positions;
}
