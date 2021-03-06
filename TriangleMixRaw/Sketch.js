function setup() {
  frameRate = 1;//60;
}

function draw() {
  levels = 255;
  side = random(16, 256);
  ox = -random(side), oy = -random(side);
  py = oy, y = oy;
  while(py < height) {
    px = ox, x = ox;
    y += side;
    while(px < width) {
      px = x;
      x += side;
      off = pick() ? 0 : random(side / 4);
      if(pick()) {
        fill(pick(levels));
        triangle(px, py, px - off, y + off, x, py);
        fill(pick(levels));
        triangle(x, py, x, y, px - off, y + off);
      } else {
        fill(pick(levels));
        triangle(px - off, py - off, px, y, x, y);
        fill(pick(levels));
        triangle(x, py, x, y, px - off, py - off);
      }
    }
    py = y;
  }
}