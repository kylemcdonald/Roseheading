/* @pjs preload="prayer.png, x.png"; */

// before matching, should do histogram normalization
// use textured squares instead of get()

PImage base, target;
PImage baseSmall, targetSmall;
PImage[] baseChop, targetChop;

int[] positions, states;
int pieces = 32;
float moveTime = 1000;

boolean debug = true;
boolean backwards = false, lastBackwards = false;
int backwardsStart = 0;

void setup() {
  size(256, 256);
  noSmooth();
  base = loadImage("street.jpg");
  target = loadImage("prayer.png");
  baseChop = new PImage[pieces * pieces];
  targetChop = new PImage[pieces * pieces];
  chop(base, baseChop);
  chop(target, targetChop);
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

void chop(PImage img, PImage[] chop) {
  int w = img.width, h = img.height;
  int pw = pieces, ph = pieces;
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
  int w = img.width, h = img.height;
  int pw = pieces, ph = pieces;
  int sw = int(w / pw), sh = int(h / ph);
  int curTime = millis();
  float backwardsDiff = curTime - backwardsStart;
  if (lastBackwards == true && backwardsDiff > moveTime) {
    backwards = false;
    // reset states
    states = new int[states.length];
  }
  lastBackwards = backwards;
  int k = 0;
  for (int y = 0; y < ph; y++) {
    for (int x = 0; x < pw; x++) {
      int cur = positions[k];
      int cy = int(cur / pw), cx = cur - (cy * pw);
      int sx = cx * sw, sy = cy * sh;
      int tx = x * sw, ty = y * sh;
      float ax, ay;
      if (debug) {
        ax = tx;
        ay = ty;
      } 
      else {
        float timeDiff = constrain(curTime - states[cur], 0, moveTime);
        if (backwards) {
          timeDiff -= backwardsDiff;
        }
        float state = states[cur] == 0 ? 0 : constrain(timeDiff / moveTime, 0, 1);
        state = smoothStep(state);
        int dx = int(abs(tx - sx)), dy = int(abs(ty - sy));
        state *= (dx + dy);
        if (dx > dy) {
          ax = dx == 0 ? tx : lerp(sx, tx, constrain(state, 0, dx) / dx);
          ay = dy == 0 ? ty : lerp(sy, ty, constrain(state - dx, 0, dy) / dy);
        } 
        else {
          ax = dx == 0 ? tx : lerp(sx, tx, constrain(state - dy, 0, dx) / dx);
          ay = dy == 0 ? ty : lerp(sy, ty, constrain(state, 0, dy) / dy);
        }
      }
      image(baseChop[cur], ax, ay);
      //image(img.get(sx, sy, sw, sh), ax, ay);
      k++;
    }
  }
}

void draw() {
  tickTimer();
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

void keyPressed() {
  if (key == 's') {
    saveFrame("screen-###.png");
  }
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

