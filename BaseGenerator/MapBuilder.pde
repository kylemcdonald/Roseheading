boolean b() {
  return random(2) > 1;
}

void buildMap(PGraphics pg, int levels) {
  int minx = 32, maxx = 128, miny = 32, maxy = 128;
  pg.beginDraw();
  pg.noSmooth();
  pg.background(0);
  pg.noStroke();
  int i = 0;
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
      
      pg.fill(i % levels);
      pg.triangle(px0, py, px1, y, x0, py);
      i++;
      
      pg.fill(i % levels);  
      pg.triangle(px1, y, x0, py, x1, y);
      i++;
    }
    py = y;
  }
  pg.endDraw();
}
