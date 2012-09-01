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
 algorithm:
 1 draw base images four times
 2 blend together with random blend functions and 50% opacity
 3 take final result and saturation all colors
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
  //ADD,SUBTRACT};
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
PGraphics regionMap, modeMap;

void setup() {
  //frameRate(.5);
  size(950, 540);
  //size(512, 512);
  noSmooth();
  images = new PImage[files.length];
  for (int i = 0; i < files.length; i++) {
    images[i] = loadImage(files[i]);
  }
  regionMap = createGraphics(width, height, JAVA2D);
  modeMap = createGraphics(width, height, JAVA2D);
}

void keyPressed() {
  if (key == 's') {
    saveFrame("###.png");
  }
}

void draw() {  
  randomSeed(mouseX);
  random(1); // some bug with the RNG makes the first number similar

  image(createBase(255), 0, 0);
  for(int i = 0; i < 4; i++) {
    PImage cur = createBase(128);
    int curMode = randomExclusive(modes.length);
    blend(cur, 0, 0, width, height, 0, 0, width, height, modes[curMode]);
  }
  saturate();
}

