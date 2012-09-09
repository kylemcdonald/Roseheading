void drawMosaic(PImage img, int width, int height, int pw, int ph, int[][] piecePositions) {
  int n = pw * ph;
  for (int i = 0; i < n; i++) {
    image(baseChop[i], piecePositions[i][0], piecePositions[i][1]);
  }
  /*
  int w = img.width, h = img.height;
  int sw = int(w / pw), sh = int(h / ph);
  int i = 0;
  for (int y = 0; y < ph; y++) {
    for (int x = 0; x < pw; x++) {
      image(img.get(x * sw, y * sh, sw, sh), piecePositions[i][0], piecePositions[i][1]);
      i++;
    }
  }
  */
}
