void drawMosaic(PImage img, int width, int height, int pw, int ph, int[][] piecePositions) {
  var canvas = externals.canvas;
  var ctx = externals.context;
  var htmlElement = img.sourceImg;
  int w = img.width, h = img.height;
  int sw = int(w / pw), sh = int(h / ph);
  int i = 0;
  for (int y = 0; y < ph; y++) {
    for (int x = 0; x < pw; x++) {
     // fill(baseSmall.pixels[i]);
      ctx.fillRect(x, y, w, h);
      //ctx.drawImage(htmlElement, 0, 0, sw, sh, 0, 0);
      //ctx.drawImage(imgData, x * sw, y * sh, sw, sh, 0, 0);//piecePositions[i][0], piecePositions[i][1]);
      i++;
    }
  }
  /*
  int n = pw * ph;
  for (int i = 0; i < n; i++) {
    image(baseChop[i], piecePositions[i][0], piecePositions[i][1]);
  }
  */
}
