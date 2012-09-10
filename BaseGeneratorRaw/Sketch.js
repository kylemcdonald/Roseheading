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
  //frameRate = 1;//60;
  dataWidth = images[0].width;
  dataHeight = images[0].height;
  setupImageData();
  setupBaseGenerator();
}

function draw() {
  createSingle();
  ctx.drawImage(base, 0, 0);
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

var base, regionMap, modeMap;
var baseImageData, regionMapImageData, modeMapImageData;
function setupBaseGenerator() {
  base = createCanvas(width, height);
  regionMap = createCanvas(width, height);
  modeMap = createCanvas(width, height);
}

function generateBase() {
  passes = pick(4);
}

function createSingle() {
  regionScale = random(32, 1024);
  modeScale = random(16, 64);
  buildTriangleField(regionMap, images.length, regionScale);
  buildTriangleField(modeMap, 255, modeScale);
  
  baseImageData = getImageData(base);
  regionMapImageData = getImageData(regionMap);
  modeMapImageData = getImageData(modeMap);
  
  var m = dataWidth * dataHeight;
  var n = width * height;
  var curChoice = 0, prevChoice = 0, curMode = 0;
  var zoom = 1, zoomBase = floor(pow(2, random(1, 6)));
  var badSync = pick();
  
  var baseData = baseImageData.data;
  var regionMapData = regionMapImageData.data;
  var modeMapData = modeMapImageData.data;
  
  var i, j = 0, k = 0;
  var blendMode = pick(4);
  print(["opaque", "screen", "multiply", "overlay"][blendMode]);
  var ar, ag, ab, br, bg, bb, cr, cg, cb, f;
  for(i = 0; i < n; i++) {
    curChoice = regionMapData[k] % images.length;
    
    if(zoom == 1) {
      j++;
    } else {
      if(badSync) {
        if(i % zoom == 0) {
          j++;
        }
      } else if(((i % width) % zoom) == 0) {
        j++;
      }
    }
    if(curChoice != prevChoice) {
      curMode = modeMapData[k];
      zoom = (curMode & 1) > 0 ? zoomBase : 1;
      if((curMode & 2) > 0) { // first line only
        j = 0;
      }
      if((curMode & 4) > 0) { // vertical sync
        j = floor(floor(i / width) / zoom) * dataWidth;
      }
      if((curMode & 8) > 0) { // horizontal sync
        j += (i % width);
      }
    }
    j %= m;
    
    ar = baseData[k];
    ag = baseData[k+1];
    ab = baseData[k+2];
    
    br = imagesData[curChoice][j*4];
    bg = imagesData[curChoice][j*4+1];
    bb = imagesData[curChoice][j*4+2];
    
    switch(blendMode) {
      case 0: // opaque
        cr = br;
        cg = bg;
        cb = bb;
        break;
      case 1: // screen
        cr = 255 - ((255 - ar) * (255 - br) >> 8);
        cg = 255 - ((255 - ag) * (255 - bg) >> 8);
        cb = 255 - ((255 - ab) * (255 - bb) >> 8);
        f = 128;
        cr = ar + ((cr - ar) * f >> 8);
        cg = ag + ((cg - ag) * f >> 8);
        cb = ab + ((cb - ab) * f >> 8);
        break;
      case 2: // multiply
        cr = (ar * br) >> 8;
        cg = (ag * bg) >> 8;
        cb = (ab * bb) >> 8;
        f = 128;
        cr = ar + ((cr - ar) * f >> 8);
        cg = ag + ((cg - ag) * f >> 8);
        cb = ab + ((cb - ab) * f >> 8);
        break;
      case 3: // overlay
        cr = ar < 128 ? ar * br >> 7 : 255 - ((255 - ar) * (255 - br) >> 7);
        cg = ag < 128 ? ag * bg >> 7 : 255 - ((255 - ag) * (255 - bg) >> 7);
        cb = ab < 128 ? ab * bb >> 7 : 255 - ((255 - ab) * (255 - bb) >> 7);
        f = 128;
        cr = ar + ((cr - ar) * f >> 8);
        cg = ag + ((cg - ag) * f >> 8);
        cb = ab + ((cb - ab) * f >> 8);
        break;
    }
    baseData[k] = cr;
    baseData[k+1] = cg;
    baseData[k+2] = cb;
    baseData[k+3] = 255;
    
    prevChoice = curChoice;
    
    k += 4;
  }
  
  getContext(base).putImageData(baseImageData, 0, 0);
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