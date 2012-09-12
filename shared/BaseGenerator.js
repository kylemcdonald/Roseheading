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

function flipnib(x) {return ((x&15)<<4)|((x&240)>>4);}
function flipopp(x) {return ((x&170)>>1)|((x&85)<<1);}
function decode(d) {
  var r, g, b, k, i = 0, n = 4 * dataWidth * dataHeight;
  while(i < n) {
    k = (i>>2)%256;
    d[i] = k^flipopp(k^flipnib(k^d[i++]));
    d[i] = k^flipopp(k^flipnib(k^d[i++]));
    d[i] = k^flipopp(k^flipnib(k^d[i++]));
    i++;
  }
}

// because these are all the same size, we could use a single
// off-screen canvas instead of one per image.
var imagesData, base, regionMap, modeMap, blendMap;;
function setupBaseGenerator() {
  dataWidth = images[0].width;
  dataHeight = images[0].height;
  imagesData = new Array(images.length);
  for(i in images) {
    imagesData[i] = imageToRaw(images[i]);
    if(files[i].indexOf("noise") != -1) {
      decode(imagesData[i]);
    }
  }
  
  base = createCanvas(width, height);
  regionMap = createCanvas(width, height);
  modeMap = createCanvas(width, height);
  blendMap = createCanvas(width, height);
}

function generateBase() {
  passes = 1 + pick(2);
  for(i = 0; i < passes; i++) {
    createSingle();
  }
  saturate();
}

function createSingle() {
  buildTriangleField(regionMap, images.length, random(8, 1024));
  buildTriangleField(modeMap, 255, random(8, 64));
  buildTriangleField(blendMap, 4, random(32, 512));
  
  var baseImageData = getImageData(base);
  var regionMapImageData = getImageData(regionMap);
  var modeMapImageData = getImageData(modeMap);
  var blendMapImageData = getImageData(blendMap);
  
  var m = dataWidth * dataHeight;
  var n = width * height;
  var curChoice = 0, prevChoice = -1, curMode = 0;
  var zoom = 1, zoomBase = floor(pow(2, random(1, 6)));
  var badSync = random() < .2;
  
  var baseData = baseImageData.data;
  var regionMapData = regionMapImageData.data;
  var modeMapData = modeMapImageData.data;
  var blendMapData = blendMapImageData.data;
  
  var i, j = 0, k = 0;
  var blendMode;
  var allOpaque = (frameCount == 0);
  
  var ar, ag, ab, br, bg, bb, cr, cg, cb, f;
  for(i = 0; i < n; i++, k+=4) {
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
      if((curMode & 2) > 0 && (curMode & 4) > 0) { // first line only
        j = 0;
      } else {
        if((curMode & 8) > 0 || (curMode & 16) > 0) { // vertical sync
          j = floor(floor(i / width) / zoom) * dataWidth;
        }
        if((curMode & 32) > 0) { // horizontal sync
          j += (i % width);
        }
      }
    }
    j %= m;
       
    br = imagesData[curChoice][j*4];
    bg = imagesData[curChoice][j*4+1];
    bb = imagesData[curChoice][j*4+2];
    
    if(allOpaque) {
      cr = br, cg = bg, cb = bb;
    } else {
      ar = baseData[k];
      ag = baseData[k+1];
      ab = baseData[k+2];
      
      switch(blendMapData[k] % 4) {
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
    }
    
    baseData[k] = cr;
    baseData[k+1] = cg;
    baseData[k+2] = cb;
    baseData[k+3] = 255;
    
    prevChoice = curChoice;
  }
  
  getContext(base).putImageData(baseImageData, 0, 0);
}

function saturate() {
  buildTriangleField(blendMap, 160, random(16, 1024));
  var baseImageData = getImageData(base);
  var blendMapImageData = getImageData(blendMap);  
  var baseData = baseImageData.data;
  var blendMapData = blendMapImageData.data;
  var n = width * height;
  var i, k = 0;
  var r, g, b, hue, saturation;
  var max, min;
  var six, sixInt, sixFrac, saturationNorm, range;
  var pv, qv, tv;
  for(i = 0; i < n; i++, k+=4) {
    r = baseData[k], g = baseData[k+1], b = baseData[k+2];
    max = r, min = r;
    if(g > max) max = g;
    if(b > max) max = b;
    if(g < min) min = g;
    if(b < min) min = b;
    if(min == max) continue; // ignore grays   
    range = max - min;
    if(r == max) {
      six = (g - b) / range;
      if(six < 0) {
        six += 6;
      }
    } else if (g == max) {
      six = 2 + (b - r) / range;
    } else {
      six = 4 + (r - g) / range;
    }
    //hue = 255 * six / 6;
    //saturation = 255 * range / max;
    sixInt = six|0;
    mode = blendMapData[k];
    if(mode < 100) {
      sixFrac = six - sixInt;
      saturationNorm = mode / 100;
      pv = ((1 - saturationNorm) * max);
      qv = ((1 - saturationNorm * sixFrac) * max);
      tv = ((1 - saturationNorm * (1 - sixFrac)) * max);
      switch(sixInt) {
        case 0: r = max, g = tv, b = pv; break; // r
        case 1: r = qv, g = max, b = pv; break; // g
        case 2: r = pv, g = max, b = tv; break; // g
        case 3: r = pv, g = qv, b = max; break; // b
        case 4: r = tv, g = pv, b = max; break; // b
        default: r = max, g = pv, b = qv; // r
      }
    } else if(mode < 150) { // cmyk-leaning transform
      switch(sixInt) {
        case 0: r = max, g = 255, b = 255; break; // r
        case 1: r = 255, g = max, b = 255; break; // g
        case 2: r = 255, g = max, b = 255; break; // g
        case 3: r = 255, g = 255, b = max; break; // b
        case 4: r = 255, g = 255, b = max; break; // b
        default: r = max, g = 255, b = 255; break; // r
      }
    } else { // desaturate
      r = g = b = max;
    }

    baseData[k] = r;
    baseData[k+1] = g;
    baseData[k+2] = b;
  }
  getContext(base).putImageData(baseImageData, 0, 0);
}

function buildTriangleField(canvas, levels, side) {
  var ctx = getContext(canvas);
  ox = -random(side), oy = -random(side);
  py = oy, y = oy;
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