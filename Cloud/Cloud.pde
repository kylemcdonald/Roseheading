PImage target;
PImage baseSmall, targetSmall;
PImage[] baseChop;

int[] positions, states;
int pieceSize = 10;
int pw, ph;
float moveTime = 2000;
int moveRadius = 16; // blocks

int zoomStart = 0;
int zoomTime = 1000;
int fadeTime = 2000;
PImage zoomBuffer;

void setup() {
  size(950, 540);
  noSmooth();
  noStroke();
  
  zoomBuffer = createImage(width, height, RGB);

  pw = int(width / pieceSize);
  ph = int(height / pieceSize);
  target = loadImage("data.png");
  baseChop = new PImage[pw * ph];

  buildScene();
}

void buildScene() {
  setupGenerator();
  generateBase(base);
  chop(base, baseChop);
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

void chop(PGraphics img, PImage[] chop) {
  int w = img.width, h = img.height;
  int sw = int(w / pw), sh = int(h / ph);
  int i = 0;
  for (int y = 0; y < ph; y++) {
    for (int x = 0; x < pw; x++) {
      chop[i] = img.get(x * sw, y * sh, sw, sh);
      i++;
    }
  }
}

void arrangePieces(PImage img) {
  img.loadPixels();

  int w = img.width, h = img.height;
  int sw = floor(w / pw), sh = floor(h / ph);
  int curTime = millis();
  int k = 0;
  for (int y = 0; y < ph; y++) {
    for (int x = 0; x < pw; x++) {
      int cur = positions[k];
      int cy = floor(cur / pw), cx = cur - (cy * pw);
      int sx = cx * sw, sy = cy * sh;
      int tx = x * sw, ty = y * sh;
      int ax, ay;
      float timeDiff = constrain(curTime - states[cur], 0, moveTime);
      float state = states[cur] == 0 ? 0 : constrain(timeDiff / moveTime, 0, 1);
      state = smoothStep(state);
      int dx = int(abs(tx - sx)), dy = int(abs(ty - sy));
      state *= (dx + dy);
      if (dx > dy) {
        ax = floor(dx == 0 ? tx : lerp(sx, tx, constrain(state, 0, dx) / dx));
        ay = floor(dy == 0 ? ty : lerp(sy, ty, constrain(state - dx, 0, dy) / dy));
      } 
      else {
        ax = floor(dx == 0 ? tx : lerp(sx, tx, constrain(state - dy, 0, dx) / dx));
        ay = floor(dy == 0 ? ty : lerp(sy, ty, constrain(state, 0, dy) / dy));
      }

      //fill(baseSmall.pixels[cur]); rect(ax, ay, sw, sh);
      image(baseChop[cur], ax, ay);
      //image(img.get(sx, sy, sw, sh), ax, ay);

      k++;
    }
  }
}

void draw() {
  int curTime = millis();
  int state = curTime - zoomStart;
  if(zoomStart > 0 && state < zoomTime) {
    float zoomNorm = float(curTime - zoomStart) / zoomTime;
    zoomNorm = smoothStep(zoomNorm);
    float zoomScale = lerp(1, 2, zoomNorm);
    translate(zoomX, zoomY);
    scale(zoomScale, zoomScale);
    translate(-zoomX, -zoomY);
    image(zoomBuffer, 0, 0);
  } else if(zoomStart > 0 && state < fadeTime) {
    translate(zoomX, zoomY);
    scale(2, 2);
    translate(-zoomX, -zoomY);
    image(zoomBuffer, 0, 0);
    buildScene();
  } else {
    arrangePieces(base);
  }
}

void trigger(int x, int y) {
  int i = y * pw + x;
  if (states[i] == 0) {
    states[i] = millis();
  }
}

int zoomX, zoomY;
void mousePressed() {
  zoomBuffer = get();
  zoomStart = millis();
  states = new int[states.length];
  zoomX = mouseX;
  zoomY = mouseY;
}

void keyPressed() {
  if (key == 's') {
    saveFrame("screen-###.png");
  }
}

void mouseMoved() {
  int x = mouseX / pieceSize, y = mouseY / pieceSize;
  if (x >= 0 && y >= 0 && x < pw && y < ph) {
    for (int i = 0; i < pw; i++) {
      for (int j = 0; j < ph; j++) {
        if (dist(i, j, x, y) < moveRadius) {
          trigger(i, j);
        }
      }
    }
  }
}

