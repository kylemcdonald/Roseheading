var files = [
  "data/pdfglitch.png", 
  "data/building.png", 
  "data/bytebeat.png", 
  "data/cmdtab.png", 
  "data/gpunoise.png", 
  "data/infinitefill.png", 
  "data/interface.png", 
  "data/stacks.png", 
  "data/street.png"
];
var images = loadImages(files);
var dataWidth, dataHeight;

function setup() {
  //frameRate = 60;
  dataWidth = images[0].width;
  dataHeight = images[0].height;
  setupImageData();
  setupBaseGenerator();
}

var imageData;
function draw() {
  createSingle();
  ctx.putImageData(baseImageData, 0, 0);
}

// because these are all the same size, we could use a single
// off-screen canvas instead of one per image.
var imagesData = new Array();
function setupImageData() {
  imagesData = new Array(images.length);
  for(i in images) {
    imagesData[i] = imageToRaw(images[i]);
  }
}

var base, modeMap;
var baseImageData, modeMapImageData;
function setupBaseGenerator() {
  base = createCanvas(width, height);
  modeMap = createCanvas(width, height);
  // maybe we can fill with alpha = 255 here?
}

function generateBase() {
  passes = pick(4);
}

function createSingle() {
  regionScale = 32;//random(32, 1024);
  modeScale = 32;//random(16, 64);
  buildTriangleField(base, images.length, regionScale);
  buildTriangleField(modeMap, 255, modeScale);
  
  baseImageData = getImageData(base);
  modeMapImageData = getImageData(modeMap);
  
  m = dataWidth * dataHeight;
  n = width * height;
  prevChoice = 0, curMode = 0;
  zoom = 1, zoomBase = floor(pow(2, random(1, 6)));
  badSync = pick();
  
  baseData = baseImageData.data;
  modeMapData = modeMapImageData.data;
  
  var i, j = 0, k = 0;
  var curChoice, verticalSync, horizontalSync, firstLineOnly;
  for(i = 0; i < n; i++) {
    curChoice = baseData[k] % images.length;
    
    if(badSync) {
      if(i % zoom == 0) {
        ++j;
      }
    } else if(((i % width) % zoom) == 0) {
      ++j;
    }
    if(curChoice != prevChoice) {
      curMode = modeMapData[k];
      verticalSync = (curMode & 1) > 0;
      horizontalSync = (curMode & 2) > 0;
      firstLineOnly = (curMode & 4) > 0;
      zoom = (curMode & 8) > 0 ? zoomBase : 1;
      if (firstLineOnly) {
        j = 0;
      }
      if (verticalSync) {
        j = floor(floor(i / width) / zoom) * dataWidth;
      }
      if (horizontalSync) {
        j += (i % width);
      }
    }
    j %= m;
    
    baseData[k] = imagesData[curChoice][j*4];
    baseData[k+1] = imagesData[curChoice][j*4+1];
    baseData[k+2] = imagesData[curChoice][j*4+2];
    baseData[k+3] = 255;
    
    // we should also handle the blending here
    
    prevChoice = curChoice;
    
    k += 4;
  }
}

function buildTriangleField(canvas, levels, side) {
  var ctx = getContext(canvas);
  ox = -random(side), oy = -random(side);
  py = oy, y = oy;
  var nwx, nwy, nex, ney, swx, swy, sex, sey;
  while(py < height) {
    px = ox, x = ox;
    y += side;
    while(px < width) {
      px = x;
      x += side;
      off = pick() ? 0 : random(side / 4);
      if(pick()) {
        fill(pick(levels), ctx);
        triangle(px, py, px - off, y + off, x, py, ctx);
        fill(pick(levels), ctx);
        triangle(x, py, x, y, px - off, y + off, ctx);
      } else {
        fill(pick(levels), ctx);
        triangle(px - off, py - off, px, y, x, y, ctx);
        fill(pick(levels), ctx);
        triangle(x, py, x, y, px - off, py - off, ctx);
      }
    }
    py = y;
  }
}