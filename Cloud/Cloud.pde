/* @pjs preload="base.png, target.png"; */

PImage base, target;
PImage baseSmall, targetSmall;
PImage[] baseChop;

int[] positions, states;
int pieceSize = 10;
int pw, ph;
float moveTime = 2000;
int moveRadius = 16; // blocks

boolean debug = false;
boolean backwards = false, lastBackwards = false;
int backwardsStart = 0;

PFont font = createFont("Arial", 10, false);

void setup() {
  size(950, 540);
  noSmooth();  
  textFont(font, 10);
  textAlign(LEFT, TOP);

  pw = int(width / pieceSize);
  ph = int(height / pieceSize);
  base = loadImage("oceanic.png");
  target = loadImage("target.png");
  baseChop = new PImage[pw * ph];
  chop(base, baseChop);
  matchTarget();
}

float smoothStep(float x) {
  return 3.*(x*x)-2.*(x*x*x);
}

void matchTarget() {
  baseSmall = createImage(pw, ph, RGB);
  resizeArea(base, baseSmall);

  targetSmall = createImage(pw, ph, RGB);
  resizeArea(target, targetSmall);

  positions = findMosaic(baseSmall, targetSmall);
  states = new int[positions.length];
}

void chop(PImage img, PImage[] chop) {
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
      int cy = floor(cur / pw), cx = cur - (cy * pw);
      int sx = cx * sw, sy = cy * sh;
      int tx = x * sw, ty = y * sh;
      int ax, ay;
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
          ax = floor(dx == 0 ? tx : lerp(sx, tx, constrain(state, 0, dx) / dx));
          ay = floor(dy == 0 ? ty : lerp(sy, ty, constrain(state - dx, 0, dy) / dy));
        } 
        else {
          ax = floor(dx == 0 ? tx : lerp(sx, tx, constrain(state - dy, 0, dx) / dx));
          ay = floor(dy == 0 ? ty : lerp(sy, ty, constrain(state, 0, dy) / dy));
        }
      }

      //rect(ax, ay, sw, sh);
      image(baseChop[cur], ax, ay);
      //image(img.get(sx, sy, sw, sh), ax, ay);

      k++;
    }
  }
}

void draw() {
  arrangePieces(base);

  fill(0);
  rect(5, 5, 100, 25);
  fill(255);
  text(frameCount + " / " + int(frameRate), 10, 10);
}

void trigger(int x, int y) {
  int i = y * pw + x;
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

// for mobile apps
void mouseDragged() {
  mouseMoved();
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

