/* @pjs preload="base.png, target.png"; */

PImage base, target;
PImage baseSmall, targetSmall;

int[] positions, states;
int pieces = 32;
float moveTime = 1000;

boolean backwards = false, lastBackwards = false;
int backwardsStart = 0;

void setup() {
  size(256, 256);
  noSmooth();
  base = loadImage("base.png");
  target = loadImage("target.png");
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
}

void arrangePieces(PImage img) {
  int w = img.width, h = img.height;
  int pw = pieces, ph = pieces;
  int sw = w / pw, sh = h / ph;
  int k = 0;
  int curTime = millis();
  float backwardsDiff = curTime - backwardsStart;
  if(lastBackwards == true && backwardsDiff > moveTime) {
    backwards = false;
    // reset states
    states = new int[states.length];
  }
  lastBackwards = backwards;
  for (int y = 0; y < ph; y++) {
    for (int x = 0; x < pw; x++) {
      int cur = positions[k];
      int cy = cur / pw, cx = cur - (cy * pw);
      int sx = cx * sw, sy = cy * sh;
      int tx = x * sw, ty = y * sh;
      int dx = abs(tx - sx), dy = abs(ty - sy);
      float timeDiff = constrain(curTime - states[cur], 0, moveTime);
      if(backwards) {
        timeDiff -= backwardsDiff;
      }
      float state = states[cur] == 0 ? 0 : constrain(timeDiff / moveTime, 0, 1);
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
  image(base, 0, 0);
  arrangePieces(base);
  image(target, 256, 0);
}


void trigger(int x, int y) {
  int i = y * pieces + x;
  if (states[i] == 0) {
    states[i] = millis();
  }
}

void mousePressed() {
  backwards = true;
  backwardsStart = millis();
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

