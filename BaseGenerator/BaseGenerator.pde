void setup() {
  size(950, 540);
  noSmooth();
  setupGenerator();
}

void keyPressed() {
  if (key == 's') {
    saveFrame("###.png");
  }
}

void draw() {  
  background(0);
  randomSeed(mouseX);
  generateBase(base);
  image(base, 0, 0);
  println(frameRate);
}

