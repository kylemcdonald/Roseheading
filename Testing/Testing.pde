int beat(int t) {
  return 0;
}

void setupBeat(string beatCode) {
  eval("beat = function(t) {return " + beatCode + "}");
}

int n;
void setup() {
  size(512, 512);
  n = width * height;
  setupBeat("t*5&(t>>7)|t*3&(t*4>>10)");
}

void draw() {
  loadPixels();
  for (int i = 0; i < n; i++) {
    pixels[i] = color(beat(i) & 255);
  }
  updatePixels();
}

