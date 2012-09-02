/* @pjs preload="base.png, target.png"; */

PImage base, target;
PImage baseSmall, targetSmall;

int[] positions, states;
int pieceSize = 10;
int pw, ph;

void setup() {
  size(950, 540);
  noSmooth();
  pw = int(width / pieceSize);
  ph = int(height / pieceSize);
  base = loadImage("base.png");
  target = loadImage("data.png");
  matchTarget();
}

void matchTarget() {
  baseSmall = createImage(pw, ph, RGB);
  resizeArea(base, baseSmall);

  targetSmall = createImage(pw, ph, RGB);
  resizeArea(target, targetSmall);

  positions = findMosaic(baseSmall, targetSmall);
  states = new int[positions.length];
}

void arrangePieces(PImage img, int pw, int ph, int[] positions) {
  img.loadPixels();
  int w = img.width, h = img.height;
  int sw = floor(w / pw), sh = floor(h / ph);
  int k = 0;
  for (int y = 0; y < ph; y++) {
    for (int x = 0; x < pw; x++) {
      int cur = positions[k];
      int cy = floor(cur / pw), cx = cur - (cy * pw);
      int sx = cx * sw, sy = cy * sh;
      int tx = x * sw, ty = y * sh;
      image(img.get(sx, sy, sw, sh), tx, ty);
      k++;
    }
  }
}

void draw() {
  arrangePieces(base, pw, ph, positions);
}


