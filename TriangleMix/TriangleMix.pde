PGraphics pg;

void setup() {
  size(950, 540);
  pg = createGraphics(width, height, JAVA2D);
}

void draw() {
  randomSeed(mouseX);
  buildTriangleField(pg, 255, 128);
  image(pg, 0, 0);
}

