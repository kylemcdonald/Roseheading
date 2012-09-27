PGraphics target;
PImage baseSmall, targetSmall;
PImage[] baseChop;

int[] positions, states;
int pieceSize = 10;
int pw, ph;
float moveTime = 2000;
int moveRadius = 16; // blocks

int zoomStart = 0;
int zoomTime = 1000;
int fadeStart = 0;
int fadeTime = 1000;
PImage zoomBuffer;

void setup() {
  size(950, 540);
  noSmooth();
  noStroke();

  zoomBuffer = createImage(width, height, RGB);
  target = createGraphics(width, height, JAVA2D);

  pw = int(width / pieceSize);
  ph = int(height / pieceSize);
  baseChop = new PImage[pw * ph];

  setupBaseGenerator();
  setupTargetGenerator();

  buildScene();
}

void buildScene() {
  zoomBuffer = get();
  generateTarget(target);
  generateBase(base);
  chop(base, baseChop, pw, ph);
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

void chop(PImage img, PImage[] chop, int pw, int ph) {
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

int[][] getPiecePositions() {
  int w = width, h = height;
  int sw = floor(w / pw), sh = floor(h / ph);
  int curTime = millis();
  int k = 0;
  int n = pw * ph;
  int[][] piecePositions = new int[n][2];
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
      piecePositions[cur][0] = ax;
      piecePositions[cur][1] = ay;
      k++;
    }
  }
  return piecePositions;
}

void arrangePieces(PImage img) {
  int[][] piecePositions = getPiecePositions();
  drawMosaic(img, width, height, pw, ph, piecePositions);
}

int lastZoomState;
void draw() {
  int curTime = millis();
  int zoomState = curTime - zoomStart;

  if (zoomStart > 0 && lastZoomState < zoomTime && zoomState >= zoomTime) {
    buildScene();
    curTime = millis();
    fadeStart = curTime;
  } 
  else {
    arrangePieces(base);
  }
  lastZoomState = zoomState;

  if (zoomStart > 0 && zoomState < zoomTime) {
    float zoomNorm = float(zoomState) / zoomTime;
    zoomNorm = smoothStep(zoomNorm);
    float zoomScale = lerp(1, 16, zoomNorm);
    translate(zoomX, zoomY);
    scale(zoomScale, zoomScale);
    translate(-zoomX, -zoomY);
    image(zoomBuffer, 0, 0);
  }

  int fadeState = curTime - fadeStart;
  if (fadeStart > 0 && fadeState < fadeTime) {
    float fadeNorm = float(fadeState) / fadeTime;
    pushStyle();
    tint(255, (1 - fadeNorm) * 255);
    image(zoomBuffer, 0, 0);
    popStyle();
  }

  println(frameRate);
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
        if (dist(i, j, x, y) < moveRadius * random(.1, 1)) {
          trigger(i, j);
        }
      }
    }
  }
}

