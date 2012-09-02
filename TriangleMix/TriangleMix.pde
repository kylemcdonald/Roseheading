PGraphics pg;

void setup() {
  frameRate(4);
  size(950, 540);
  pg = createGraphics(width, height, JAVA2D);
}

void draw() {
  buildMap(pg, 255, 128, -64, -64);
  image(pg, 0, 0);
}

int randomExclusive(int n) {
  return int(min(random(n), n - 1));
}

boolean b() {
  return random(2) > 1;
}

void buildMap(PGraphics pg, int levels, int side, int ox, int oy) {
  pg.beginDraw();
  pg.noSmooth();
  pg.background(0);
  pg.noStroke();
  int py = oy, y = oy;
  while(py < height) {
    int px = ox, x = ox;
    y += side;
    while(px < width) {
      px = x;
      x += side;
      if(b()) {
        pg.fill(randomExclusive(levels));
        pg.triangle(px, py, px, y, x, py);
        pg.fill(randomExclusive(levels));
        pg.triangle(x, py, x, y, px, y);
      } else {
        pg.fill(randomExclusive(levels));
        pg.triangle(px, py, px, y, x, y);
        pg.fill(randomExclusive(levels));
        pg.triangle(x, py, x, y, px, py);
      }
    }
    py = y;
  }
  pg.endDraw();
}
