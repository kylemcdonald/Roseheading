String[] files = {
  "pdfglitch.png"
  /*"building.png", 
  "bytebeat.png", 
  "cmdtab.png", 
  "gpunoise.png", 
  "infinitefill.png", 
  "interface.png", 
  "stacks.png", 
  "street.png",*/
};

int[] modes = {
  SCREEN, OVERLAY, SUBTRACT, MULTIPLY, ADD, SOFT_LIGHT, HARD_LIGHT, DODGE, BURN
  //SUBTRACT, SCREEN, OVERLAY, SCREEN, OVERLAY
  //BURN, SCREEN, OVERLAY, SCREEN, OVERLAY
  //SUBTRACT, SCREEN, SOFT_LIGHT, SCREEN, SOFT_LIGHT
  //SCREEN, OVERLAY
  //SCREEN, MULTIPLY
  //SUBTRACT, ADD
};

PImage[] images;
PGraphics base, regionMap, modeMap, saturateMap;
void setupGenerator() {
  images = new PImage[files.length];
  for (int i = 0; i < files.length; i++) {
    images[i] = loadImage(files[i]);
  }
  // can reuse these, only 2 in use at a given time
  base = createGraphics(width, height, JAVA2D);
  regionMap = createGraphics(width, height, JAVA2D);
  modeMap = createGraphics(width, height, JAVA2D);
  saturateMap = createGraphics(width, height, JAVA2D);
}

void generateBase(PGraphics pg) {
  int passes = 4;
  pg.beginDraw();
  pg.noSmooth();
  if(frameCount == 0) {
    pg.image(createSingle(255), 0, 0);
  } else {
    pg.pushMatrix();
    pg.translate(zoomX, zoomY);
    pg.scale(2, 2);
    pg.translate(-zoomX, -zoomY);
    pg.image(zoomBuffer, 0, 0);
    pg.popMatrix();
  }
  for (int i = 0; i < passes; i++) {
    PImage cur = createSingle(128);
    //int curMode = i % modes.length;
    int curMode = randomExclusive(modes.length);
    pg.blend(cur, 0, 0, width, height, 0, 0, width, height, modes[curMode]);
  }
  saturate(pg);
  pg.endDraw();
  pg.loadPixels();
}

color saturate(color in, int mode) {
  return in;
  /*
  float curSaturation = saturation(in);
  if(curSaturation == 0) {
    return in;
  }
  float bright = brightness(in);
  float hueSix = hue(in) * 6 / 255;
  int hueSixCategory = int(hueSix);
  if(mode < 10) {  // standard saturation transform
    float hueSixRemainder = hueSix - hueSixCategory;
    float saturationNorm = mode / 10.;
    float pv = ((1 - saturationNorm) * bright);
    float qv = ((1 - saturationNorm * hueSixRemainder) * bright);
    float tv = ((1 - saturationNorm * (1 - hueSixRemainder)) * bright);
    switch(hueSixCategory) {
      case 0: return color(bright, tv, pv); // r
      case 1: return color(qv, bright, pv); // g
      case 2: return color(pv, bright, tv); // g
      case 3: return color(pv, qv, bright); // b
      case 4: return color(tv, pv, bright); // b
      default: return color(bright, pv, qv); // r
    }
  } else if (mode < 15) { // cmyk-leaning transform
    switch(hueSixCategory) {
      
      case 0: return color(bright, 255, 255); // r
      case 1: return color(255, bright, 255); // g
      case 2: return color(255, bright, 255); // g
      case 3: return color(255, 255, bright); // b
      case 4: return color(255, 255, bright); // b
      default: return color(bright, 255, 255); // r
      
      case 0: return color(0, bright, bright); // r
      case 1: return color(bright, 0, bright); // g
      case 2: return color(bright, 0, bright); // g
      case 3: return color(bright, bright, 0); // b
      case 4: return color(bright, bright, 0); // b
      default: return color(0, bright, bright); // r
    }
  } else { // threshold
    return bright > 128 ? color(255) : color(0);
  }*/
}

void saturate(PGraphics pg) {
  buildMap(saturateMap, 17, int(random(1, 8) * 128));
  int n = pg.width * pg.height;
  pg.loadPixels();
  for (int i = 0; i < n; i++) {
    pg.pixels[i] = saturate(pg.pixels[i], saturateMap.pixels[i] & 0xff);
  }
  pg.updatePixels();
}

boolean b() {
  return random(2) > 1;
}

int randomExclusive(int n) {
  return int(min(random(n), n - 1));
}

void buildMap(PGraphics pg, int levels, int side) {
  pg.beginDraw();
  pg.noSmooth();
  pg.noStroke();
  pg.background(0);
  int ox = int(-random(side)), oy = int(-random(side));
  int py = oy, y = oy;
  while(py < height) {
    int px = ox, x = ox;
    y += side;
    while(px < width) {
      px = x;
      x += side;
      float off = b() ? 0 : random(side / 4);
      if(b()) {
        pg.fill(randomExclusive(levels));
        pg.triangle(px, py, px - off, y + off, x, py);
        pg.fill(randomExclusive(levels));
        pg.triangle(x, py, x, y, px - off, y + off);
      } else {
        pg.fill(randomExclusive(levels));
        pg.triangle(px - off, py - off, px, y, x, y);
        pg.fill(randomExclusive(levels));
        pg.triangle(x, py, x, y, px - off, py - off);
      }
    }
    py = y;
  }
  pg.endDraw();
  pg.loadPixels();
}

PImage createSingle(int alphaValue) {
  PImage base = createImage(width, height, ARGB);
  
  float regionScale = random(32, 1024), modeScale = random(16, 64);
  buildMap(regionMap, images.length, int(regionScale));
  buildMap(modeMap, 255, int(modeScale));

  int alphaMask = color(255, alphaValue);
  int m = 512 * 512;
  int n = width * height;
  int j = 0;
  int prevChoice = 0;
  
  base.loadPixels();
  int zoomBase = int(pow(2, int(random(1, 6))));
  int zoom = 1;
  boolean badSync = random(2) > 1;
  for (int i = 0; i < n; ++i) {
    int curChoice = regionMap.pixels[i] & 0xff;
    if(badSync) {
      if(i % zoom == 0) {
        ++j;
      }
    } else {
      if(((i % width) % zoom) == 0) {
        ++j;
      }
    }
    if (curChoice != prevChoice) {
      int curMode = modeMap.pixels[i] & 0xff;
      boolean verticalSync = (curMode & 1) > 0;
      boolean horizontalSync = (curMode & 2) > 0;
      boolean firstLineOnly = (curMode & 4) > 0;
      zoom = (curMode & 8) > 0 ? zoomBase : 1;
      if (firstLineOnly) {
        j = 0;
      }
      if (verticalSync) {
        j = int(int(i / width) / zoom) * 512;
      }
      if (horizontalSync) {
        j += (i % width);
      }
    }
    j %= m;
    base.pixels[i] = images[curChoice].pixels[j] & alphaMask;
    prevChoice = curChoice;
  }
  base.updatePixels();
  
  return base;
}
