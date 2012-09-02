boolean b() {
  return random(2) > 1;
}

int randomExclusive(int n) {
  return int(min(random(n), n - 1));
}

void buildMap(PGraphics pg, int levels, int side, int ox, int oy) {
  pg.beginDraw();
  pg.noSmooth();
  pg.noStroke();
  pg.background(0);
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
