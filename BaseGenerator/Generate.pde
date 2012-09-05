/* @pjs preload="pdfglitch.png, building.png, bytebeat.png, cmdtab.png, gpunoise.png, infinitefill.png, interface.png, stacks.png, street.png"; */

String[] files = {
  "pdfglitch.png", 
  "building.png", 
  "bytebeat.png", 
  "cmdtab.png", 
  "gpunoise.png", 
  "infinitefill.png", 
  "interface.png", 
  "stacks.png", 
  "street.png"
};

int[] modes = {
  SCREEN, OVERLAY
};

PImage[] images;
PGraphics base, regionMap, modeMap;
void setupGenerator() {
  images = new PImage[files.length];
  for (int i = 0; i < files.length; i++) {
    images[i] = loadImage(files[i]);
  }
  // can reuse these, only 2 in use at a given time
  base = createGraphics(width, height, JAVA2D);
  regionMap = createGraphics(width, height, JAVA2D);
  modeMap = createGraphics(width, height, JAVA2D);
}

void generateBase(PGraphics pg) {
  int passes = 0;
  pg.beginDraw();
  pg.noSmooth();
  pg.image(createSingle(255), 0, 0);
  for (int i = 0; i < passes; i++) {
    PImage cur = createSingle(128);
    int curMode = randomExclusive(modes.length);
    pg.blend(cur, 0, 0, width, height, 0, 0, width, height, modes[curMode]);
  }
  pg.endDraw();
  saturate(pg);
}

color saturateColor(color c, int mode) {
  float curSaturation = saturation(c);
  if (curSaturation == 0) {
    return c;
  }
  float bright = brightness(c);
  float hueSix = hue(c) * 6 / 255;
  int hueSixCategory = int(hueSix);
  if (mode < 10) {  // standard saturation transform
    float hueSixRemainder = hueSix - hueSixCategory;
    float saturationNorm = mode / 10.;
    float pv = ((1 - saturationNorm) * bright);
    float qv = ((1 - saturationNorm * hueSixRemainder) * bright);
    float tv = ((1 - saturationNorm * (1 - hueSixRemainder)) * bright);
    switch(hueSixCategory) {
    case 0: 
      return color(bright, tv, pv); // r
    case 1: 
      return color(qv, bright, pv); // g
    case 2: 
      return color(pv, bright, tv); // g
    case 3: 
      return color(pv, qv, bright); // b
    case 4: 
      return color(tv, pv, bright); // b
    default: 
      return color(bright, pv, qv); // r
    }
  } 
  else if (mode < 15) { // rgbw-leaning transform
    switch(hueSixCategory) {
    case 0: 
      return color(bright, 255, 0); // r
    case 1: 
      return color(bright, bright, 0); // g
    case 2: 
      return color(255, bright, 0); // g
    case 3: 
      return color(0, bright, bright); // b
    case 4: 
      return color(0, 255, bright); // b
    default: 
      return color(bright, bright, 0); // r
    }
  } 
  else if (mode < 20) { // cmyk-leaning transform
    switch(hueSixCategory) {
    case 0: 
      return color(bright, 255, 255); // r
    case 1: 
      return color(255, bright, 255); // g
    case 2: 
      return color(255, bright, 255); // g
    case 3: 
      return color(255, 255, bright); // b
    case 4: 
      return color(255, 255, bright); // b
    default: 
      return color(bright, 255, 255); // r
    }
  } 
  else { // threshold
    return bright > 128 ? color(255) : color(0);
  }
}

void saturate(PGraphics pg) {
  buildTriangleField(modeMap, 24, int(random(1, 8) * 128));
  int n = pg.width * pg.height;
  pg.beginDraw();
  pg.loadPixels();
  for (int i = 0; i < n; i++) {
    pg.pixels[i] = saturateColor(pg.pixels[i], modeMap.pixels[i] & 0xff);
  }
  pg.updatePixels();
  pg.endDraw();
}

PImage createSingle(int alphaValue) {
  PImage single = createImage(width, height, ARGB);

  float regionScale = random(32, 1024), modeScale = random(16, 64);
  buildTriangleField(regionMap, images.length, int(regionScale));
  buildTriangleField(modeMap, 255, int(modeScale));

  int alphaMask = color(255, alphaValue);
  int m = 512 * 512;
  int n = width * height;
  int j = 0;
  int prevChoice = 0;

  single.loadPixels();
  int zoomBase = int(pow(2, int(random(1, 6))));
  int curMode;
  boolean verticalSync, horizontalSync, firstLineOnly;
  int zoom = 1;
  boolean badSync = random(2) > 1;
  for (int i = 0; i < n; ++i) {
    int curChoice = regionMap.pixels[i] & 0xff;
    if (badSync) {
      if (i % zoom == 0) {
        ++j;
      }
    } 
    else if (((i % width) % zoom) == 0) {
      ++j;
    }
    if (curChoice != prevChoice) {
      curMode = modeMap.pixels[i] & 0xff;
      verticalSync = (curMode & 1) > 0;
      horizontalSync = (curMode & 2) > 0;
      firstLineOnly = (curMode & 4) > 0;
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
    single.pixels[i] = images[curChoice].pixels[j] & alphaMask;
    prevChoice = curChoice;
  }
  single.updatePixels();
  
  return single;
}

