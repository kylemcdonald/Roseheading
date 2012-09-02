String[] names;
int fontSize = 200;
PFont font = createFont("Arial", fontSize);

void setupTargetGenerator() {
  names = loadStrings("names.txt");
}

void generateTarget(PGraphics pg) {
  pg.beginDraw();
  pg.background(255);
  pg.fill(0);
  pg.noStroke();
  pg.textFont(font, fontSize);
  pg.textAlign(CENTER, CENTER);
  pg.text(names[randomExclusive(names.length)], width / 2, height / 2);
  pg.endDraw();
  pg.loadPixels();
}

