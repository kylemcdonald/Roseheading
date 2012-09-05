void setup() {
  size(512, 512);
  noStroke();
  noSmooth();
}

void draw() {
  background(0);
  float[] nw = {0, 0}, ne = {128, 0}, sw = {0, 128}, se = {128, 128};
  
  translate(192, 192);
  
  fill(64);
  triangle(nw[0], nw[1], ne[0], ne[1], sw[0], sw[1]);
  
  fill(192);
  triangle(ne[0], ne[1], sw[0], sw[1], se[0], se[1]);
}
