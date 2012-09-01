boolean b() {
  return random(2) > 1;
}

void buildMap(PGraphics pg, int levels) {
  int minRange = 100, maxRange = 1000;
  pg.beginDraw();
  pg.background(0);
  pg.noStroke();
  pg.noSmooth();
  for(int i = 0; i < levels; i++) {
    float curRange = map(i, 0, levels, maxRange, minRange);
    pg.fill(i);
    pg.beginShape(TRIANGLES);
    if(b()) {
      float x0 = random(width);
      pg.vertex(x0, 0);
      pg.vertex(x0, height);
      float x1 = x0 + (b() ? 1 : -1) * random(curRange);
      pg.vertex(x1, b() ? 0 : height);
    } else {
      float y0 = random(height);
      pg.vertex(0, y0);
      pg.vertex(width, y0);
      float y1 = y0 + (b() ? 1 : -1) * random(curRange);
      pg.vertex(b() ? 0 : width, y1);
    }
    pg.endShape();
  }
  pg.endDraw();
}
