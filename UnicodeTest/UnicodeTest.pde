int fontSize = 128;
PFont font = loadFont("Arial");

void setup() {
  size(512, 512);
  textFont(font, fontSize);
  textAlign(LEFT, TOP);
}
void draw() {
  background(0);
  int w = width / fontSize, h = height / fontSize;
  //translate(hspace / 2, vspace / 2);
  for(int x = 0; x < w; x++) {
    for(int y = 0; y < h; y++) {
      text(char(pow(random(0, 1), 10) * 4 * 4096), x * fontSize, y * fontSize);
    }
  }
}

