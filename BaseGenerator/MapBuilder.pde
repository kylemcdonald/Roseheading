boolean b() {
  return random(2) > 1;
}

int randomExclusive(int n) {
  return int(min(random(n), n - 1));
}

void buildMap(PGraphics pg, int levels, int side) {
  pg.beginDraw();
  pg.noSmooth();
  pg.noStroke();
  pg.background(0);
  int ox = int(-random(side)), oy = int(-random(side));
  int py = oy, y = oy;
  while(py < height) {
    int px = ox, x = ox;
    y += side;
    while(px < width) {
      px = x;
      x += side;
      float off = b() ? 0 : random(side / 4);
      if(b()) {
        pg.fill(randomExclusive(levels));
        pg.triangle(px, py, px - off, y + off, x, py);
        pg.fill(randomExclusive(levels));
        pg.triangle(x, py, x, y, px - off, y + off);
      } else {
        pg.fill(randomExclusive(levels));
        pg.triangle(px - off, py - off, px, y, x, y);
        pg.fill(randomExclusive(levels));
        pg.triangle(x, py, x, y, px - off, py - off);
      }
    }
    py = y;
  }
  pg.endDraw();
  pg.loadPixels();
}
