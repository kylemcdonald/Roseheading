/* @pjs preload="base.png, target.png"; */

PImage base, target;
PImage baseSmall, targetSmall;

int[] positions;
int pieces = 32;


void setup() {
  size(512, 256);
  noSmooth();
  base = loadImage("base.png");
  target = loadImage("xo.png");

  baseSmall = createImage(pieces, pieces, RGB);
  resizeArea(base, baseSmall);
  targetSmall = createImage(pieces, pieces, RGB);
  resizeArea(target, targetSmall);

  positions = findMosaic(baseSmall, targetSmall);
}

void arrangePieces(PImage img, int[] positions, int pw, int ph) {
  int w = img.width, h = img.height;
  int sw = w / pw, sh = h / ph;
  int k = 0;
  for (int y = 0; y < ph; y++) {
    for (int x = 0; x < pw; x++) {
      int cur = positions[k];
      int cy = cur / pw;
      int cx = cur - (cy * pw);
      image(img.get(cx * sw, cy * sh, sw, sh), x * sw, y * sh);
      k++;
    }
  }
}

void draw() {
  image(base, 0, 0);
  image(target, 256, 0);
  if (mousePressed) {
    image(baseSmall, 0, 0, 256, 256);
    image(targetSmall, 256, 0, 256, 256);

    arrangePieces(base, positions, pieces, pieces);
  }
}

