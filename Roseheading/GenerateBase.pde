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
  //BLEND, ADD, SUBTRACT, DARKEST, LIGHTEST, DIFFERENCE, EXCLUSION, MULTIPLY, SCREEN, OVERLAY, HARD_LIGHT, SOFT_LIGHT, DODGE, BURN
};

PImage[] images;
PGraphics base, regionMap, modeMap;
void setupBaseGenerator() {
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
  int passes =  floor(random(1, 4));
  pg.beginDraw();
  pg.noSmooth();
  if(frameCount == 0) {
    pg.image(createSingle(255), 0, 0);
  } else {
    pg.image(zoomBuffer, 0, 0);
  }
  for (int i = 0; i < passes; i++) {
    PImage cur = createSingle(128);
    int curMode = randomExclusive(modes.length);
    pg.blend(cur, 0, 0, width, height, 0, 0, width, height, modes[curMode]);
  }
  pg.endDraw();
  saturate(pg);
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
    // we should also handle the blending while we're looping through here
    prevChoice = curChoice;
  }
  single.updatePixels();
  
  return single;
}

