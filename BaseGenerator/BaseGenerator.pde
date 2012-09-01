/* @pjs preload=
 "building.png", 
 "bytebeat.png", 
 "cmdtab.png", 
 "gpunoise.png", 
 "infinitefill.png", 
 "interface.png", 
 "pdfglitch.png", 
 "stacks.png", 
 "street.png"; */

/*
 first draw colored regions that act as instructions
 do this into an image choice buffer and a blend mode buffer
 and a scaling buffer?
 do this multiple times (2x, 3x)
 same idea as the shader code from infinite fill
 */

String[] files = {
  "building.png", 
  "bytebeat.png", 
  "cmdtab.png", 
  "gpunoise.png", 
  "infinitefill.png", 
  "interface.png", 
  "pdfglitch.png", 
  "stacks.png", 
  "street.png"
};

int[] modes = {
  ADD, 
  SUBTRACT, 
  DARKEST, 
  LIGHTEST, 
  DIFFERENCE, 
  EXCLUSION, 
  MULTIPLY, 
  SCREEN, 
  OVERLAY, 
  HARD_LIGHT, 
  SOFT_LIGHT, 
  DODGE, 
  BURN
};

PImage[] images;
PGraphics regionMap;

void setup() {
  frameRate(.5);
  size(950, 540);
  //size(512, 512);
  noSmooth();
  images = new PImage[files.length];
  for (int i = 0; i < files.length; i++) {
    images[i] = loadImage(files[i]);
  }
  regionMap = createGraphics(width, height, JAVA2D);
}

void keyPressed() {
  if (key == 's') {
    saveFrame("###.png");
  }
}

void draw() {
  background(128);
  //randomSeed(mouseX);

  buildMap(regionMap, images.length);
  regionMap.loadPixels();

  loadPixels();
  int n = width * height;
  int m = 512 * 512;
  int j = 0;
  int prevChoice = 0;
  boolean verticalSync = true;
  boolean horizontalSync = true;
  boolean firstLineOnly = false;
  for (int i = 0; i < n; ++i) {
    int curChoice = regionMap.pixels[i] & 0xff;
    pixels[i] = images[curChoice].pixels[j];
    ++j;
    if (curChoice != prevChoice) {
      if (verticalSync) {
        j = (i / width) * 512;
      }
      if (horizontalSync) {
        j += i % width;
      }
      if (firstLineOnly) {
        j = 0;
      }
    }
    j %= m;
    prevChoice = curChoice;
  }
  updatePixels();
}

