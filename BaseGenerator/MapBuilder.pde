boolean b() {
  return random(2) > 1;
}

int randomExclusive(int n) {
  return int(min(random(n), n - 1));
}

void buildMap(PGraphics pg, int levels, int minScale, int maxScale) {
  buildMap(pg, levels, minScale, maxScale, minScale, maxScale);
}

void buildMap(PGraphics pg, int levels, int minx, int maxx, int miny, int maxy) {
  pg.beginDraw();
  pg.noSmooth();
  pg.background(0);
  pg.noStroke();
  float py = 0, y = 0;
  while(py < height) {
    float px0 = 0, px1 = 0;
    float x0 = 0, x1 = 0;
    y += random(miny, maxy);
    while(px0 < width || px1 < width) {
      px0 = x0;
      px1 = x1;
      x0 += random(minx, maxx);
      x1 += random(minx, maxx);
      
      if(b()) {
        pg.fill(randomExclusive(levels));
        pg.triangle(px0, py, px0, y, x0, py);
        pg.fill(randomExclusive(levels));
        pg.triangle(x0, py, x0, y, px0, y);
      } else {
        pg.fill(randomExclusive(levels));
        pg.triangle(px0, py, px0, y, x0, y);
        pg.fill(randomExclusive(levels));
        pg.triangle(x0, py, x0, y, px0, py);
      }
    }
    py = y;
  }
  pg.endDraw();
}
