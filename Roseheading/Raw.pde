void drawMosaic(PImage img, int width, int height, int pw, int ph, int[][] piecePositions) {
   int n = pw * ph;
  for (int i = 0; i < n; i++) {
    image(baseChop[i], piecePositions[i][0], piecePositions[i][1]);
  }
}
