/* @pjs preload=
  "building.png", 
  "bytebeat.png", 
  "cmdtab.png", 
  "gpunoise.png", 
  "infinitefill.png", 
  "interface.png", 
  "pdfglitch.png", 
  "stacks.png", 
  "street.png"; */

String[] files = {
  "building.png", 
  "bytebeat.png", 
  "cmdtab.png", 
  "gpunoise.png", 
  "infinitefill.png", 
  "interface.png", 
  "pdfglitch.png", 
  "stacks.png", 
  "street.png"
};

int[] modes = {
  ADD,
  SUBTRACT,
  DARKEST,
  LIGHTEST,
  DIFFERENCE,
  EXCLUSION,
  MULTIPLY,
  SCREEN,
  OVERLAY,
  HARD_LIGHT,
  SOFT_LIGHT,
  DODGE,
  BURN
};

PImage[] images;

void setup() {
  //frameRate(.5);
  size(950, 540);
  noSmooth();
  images = new PImage[files.length];
  for (int i = 0; i < files.length; i++) {
    images[i] = loadImage(files[i]);
  }
}

void blendNN(PImage srcImg, int sx, int sy, int sw, int sh, int dx, int dy, int dw, int dh, int blendMode) {
  int ox = dx, oy = dy, ow = dh, oh = dh;
  dx = constrain(dx, 0, width);
  dy = constrain(dy, 0, height);
  dw = constrain(dw, 0, width - dx);
  dh = constrain(dh, 0, height - dy);
  //println(sx + "  " + sy + " " + sw + " " + sh + " " + dx + " " + dy + " " + dw + " " + dh);
  for(int di = 0; di < dh; di++) {
    for(int dj = 0; dj < dw; dj++) {
      int si = int((di * sh) / dh), sj = int((dj * sw) / dw);
      int sk = (sy + si) * sw + sx + sj;
      int dk = (dy + di) * dw + dx + dj;
      pixels[dk] = blendColor(pixels[dk], srcImg.pixels[sk], blendMode);
    }
  }
}

void tileBlend(PImage srcImg, int x, int y, int blendMode, int scaleAmount) {
  int w = srcImg.width, h = srcImg.height;
  int dw = w * scaleAmount, dh = h * scaleAmount;
  int startX = int(x % dw) - dw, startY = int(y % dh) - dh;
  int xc = int(width / dw) + 2, yc = int(height / dh) + 2;
  for(int i = 0; i < xc; i++) {
    for(int j = 0; j < yc; j++) {
      blendNN(srcImg, 0, 0, w, h,
        int(startX + i * dw), int(startY + j * dh),
        dw, dh, blendMode);
    }
  }
}

void draw() {
  background(128);
  //randomSeed(mouseX);
  loadPixels();
  for (int i = 0; i < 8; i++) {
    int j = int(constrain(random(images.length), 0, images.length - 1));
    int k = int(constrain(random(modes.length), 0, modes.length - 1));
    int w = images[j].width, h = images[j].height;
    int subw = int(random(w / 4, w)), subh = int(random(h / 4, h));
    int subx = int(random(w - subw)), suby = int(random(h - subh));
    PImage subsection = images[j].get(subx, suby, subw, subh);
    subsection.loadPixels();
    int x = int(random(width)), y = int(random(height));
    tileBlend(subsection, x, y, modes[k], int(random(1, 4)));
  }
  updatePixels();
}

