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
  images = new PImage[files.length];
  for (int i = 0; i < files.length; i++) {
    images[i] = loadImage(files[i]);
  }
}

void tileBlend(PImage srcImg, int x, int y, int blendMode, int scaleAmount) {
  int w = srcImg.width, h = srcImg.height;
  int dw = w * scaleAmount, dh = h * scaleAmount;
  int startX = int(x % w) - w, startY = int(y % h) - h;
  int xc = int(width / w) + 2, yc = int(height / h) + 2;
  for(int i = 0; i < xc; i++) {
    for(int j = 0; j < yc; j++) {
      blend(srcImg, 0, 0, w, h,
        int(startX + i * w), int(startY + j * h),
        w, h, blendMode);
    }
  }
}

void draw() {
  background(128);
  //randomSeed(mouseX);
  for (int i = 0; i < 4; i++) {
    int j = int(constrain(random(images.length), 0, images.length - 1));
    int k = int(constrain(random(modes.length), 0, modes.length - 1));
    int w = images[j].width, h = images[j].height;
    int subw = int(random(w / 4, w)), subh = int(random(h / 4, h));
    int subx = int(random(w - subw)), suby = int(random(h - subh));
    PImage subsection = images[j].get(subx, suby, subw, subh);
    int x = int(random(width)), y = int(random(height));
    tileBlend(subsection, x, y, modes[k], int(random(1, 8)));
  }
}

