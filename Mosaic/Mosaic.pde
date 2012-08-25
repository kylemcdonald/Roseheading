/* @pjs preload="base.png, target.png"; */

PImage base, target;
PImage baseSmall, targetSmall;

void setup() {
  size(512, 256);
  noSmooth();
  base = loadImage("base.png");
  target = loadImage("target.png");
  
  baseSmall = createImage(16, 16, RGB);
  resizeArea(base, baseSmall);
  targetSmall = createImage(16, 16, RGB);
  resizeArea(target, targetSmall);
  
  println(findMosaic(baseSmall, targetSmall));
}

void draw() {
  image(base, 0, 0);
  image(target, 256, 0);
  if(mousePressed) {
    image(baseSmall, 0, 0, 256, 256);
    image(targetSmall, 256, 0, 256, 256);
  }
}
