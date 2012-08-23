PImage base, target;
PImage baseSmall, targetSmall;

void setup() {
  size(512, 256);
  noSmooth();
  base = loadImage("base.png");
  target = loadImage("target.png");
  baseSmall = createImage(16, 16, RGB);
  resizeArea(base, baseSmall);
}

void draw() {
  image(base, 0, 0);
  image(target, 256, 0);
  if(mousePressed) {
    image(baseSmall, 0, 0, 256, 256);
  }
}
