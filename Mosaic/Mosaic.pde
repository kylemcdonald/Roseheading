/* @pjs preload="base.png, target.png"; */

PImage base, target;
PImage baseSmall, targetSmall;

int[] positions;
int[] states, prevStates;
int pieces = 32;
float moveTime = 1000;
float startZoom = 0;
float zoomTime = 2000;
int clickX, clickY;

void setup() {
  size(256, 256);
  noSmooth();
  base = loadImage("base.png");
  target = loadImage("x.png");
  matchTarget();
}

float smoothStep(float x) {
  return 3.*(x*x)-2.*(x*x*x);
}

void matchTarget() {
  baseSmall = createImage(pieces, pieces, RGB);
  resizeArea(base, baseSmall);
  targetSmall = createImage(pieces, pieces, RGB);
  resizeArea(target, targetSmall);

  positions = findMosaic(baseSmall, targetSmall);
  states = new int[positions.length];
  prevStates = new int[positions.length];
}

void arrangePieces(PImage img, int[] positions, int[] states, int pw, int ph) {
  int w = img.width, h = img.height;
  int sw = w / pw, sh = h / ph;
  int k = 0;
  int curTime = millis();
  for (int y = 0; y < ph; y++) {
    for (int x = 0; x < pw; x++) {
      int cur = positions[k];
      int cy = cur / pw, cx = cur - (cy * pw);
      int sx = cx * sw, sy = cy * sh;
      int tx = x * sw, ty = y * sh;
      int dx = abs(tx - sx), dy = abs(ty - sy);
      float state = states[cur] == 0 ? 0 : constrain((curTime - states[cur]) / moveTime, 0, 1);
      state = smoothStep(state);
      float distance = dx + dy;
      state *= distance;
      float ax, ay;
      if (dx > dy) {
        ax = lerp(sx, tx, constrain(state, 0, dx) / dx);
        ay = lerp(sy, ty, constrain(state - dx, 0, dy) / dy);
      } 
      else {
        ax = lerp(sx, tx, constrain(state - dy, 0, dx) / dx);
        ay = lerp(sy, ty, constrain(state, 0, dy) / dy);
      }
      image(img.get(sx, sy, sw, sh), ax, ay);
      k++;
    }
  }
}

void draw() {
  background(0);

  float zoomAmount = (millis() - startZoom) / zoomTime;
  pushStyle();
  if (startZoom > 0 && zoomAmount > 0 && zoomAmount < 1) {
    float zoom = map(pow(zoomAmount, 2), 0, 1, 1, pieces);
    pushMatrix();
    translate(clickX, clickY);
    scale(zoom, zoom);
    translate(-clickX, -clickY);
    tint(255);
    image(base, 0, 0);
    arrangePieces(base, positions, prevStates, pieces, pieces);
    popMatrix();

    pushMatrix();
    translate(clickX, clickY);
    scale(zoom / pieces, zoom / pieces);
    translate(-clickX, -clickY);
    tint(255, map(pow(zoomAmount, .2), 0, 1, 0, 255));
    image(base, 0, 0);
    popMatrix();
  } 
  else {
    image(base, 0, 0);
    arrangePieces(base, positions, states, pieces, pieces);
  }
  popStyle();

  image(target, 256, 0);
}


void trigger(int x, int y) {
  int i = y * pieces + x;
  if (states[i] == 0) {
    states[i] = millis();
  }
}

void mousePressed() {
  clickX = mouseX;
  clickY = mouseY;
  startZoom = millis();
  arrayCopy(states, prevStates);
  states = new int[states.length];
}

void mouseMoved() {
  int pw = base.width / pieces, ph = base.height / pieces;
  int x = mouseX / pw, y = mouseY / ph;
  if (x >= 0 && y >= 0 && x < pieces && y < pieces) {
    for (int i = 0; i < pieces; i++) {
      for (int j = 0; j < pieces; j++) {
        if (dist(i, j, x, y) < 8) {
          trigger(i, j);
        }
      }
    }
  }
}

