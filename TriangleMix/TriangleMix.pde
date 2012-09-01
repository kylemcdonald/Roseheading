PGraphics pg;

void setup() {
  frameRate(2);
  size(950, 540);
  pg = createGraphics(width, height, JAVA2D);
}

void draw() {
  buildMap(pg, 10);
  image(pg, 0, 0);
}

boolean b() {
  return random(2) > 1;
}

void buildMap(PGraphics pg, int levels) {
  int minx = 32, maxx = 128, miny = 32, maxy = 128;
  pg.beginDraw();
  pg.noSmooth();
  pg.background(0);
  //pg.noStroke();
  float py = 0, y = 0;
  while(py < height) {
    pg.beginShape(TRIANGLE_STRIP);
    float px0 = 0, px1 = 0;
    float x0 = 0, x1 = 0;
    while(px0 < width || px1 < width) {
      pg.vertex(x0, py);
      pg.vertex(x1, y);
      px0 = x0;
      px1 = x1;
      x0 += random(minx, maxx);
      x1 += random(minx, maxx);
    }
    pg.endShape();
    py = y;
    y += random(miny, maxy);
  }
  pg.endDraw();
}
