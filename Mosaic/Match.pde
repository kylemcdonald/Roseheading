class MatchPair {
  int src, dst;
  MatchPair(int src, int dst) {
    this.src = src;
    this.dst = dst;
  }
}

int[] findMosaic(PImage srcImg, PImage dstImg) {
  int w = srcImg.width, h = srcImg.height;
  int n = w * h, n2 = n * n;

  color[] src = srcImg.pixels, dst = dstImg.pixels;

  tickTimer();  
  int binCount = 256;
  ArrayList[] bins = new ArrayList[binCount];
  for (int i = 0; i < binCount; i++) {
    bins[i] = new ArrayList();
  }
  println("allocating bins: " + tickTimer());

  int[] srcBright = new int[n], dstBright = new int[n];
  for(int i = 0; i < n; i++) {
    srcBright[i] = (int) brightness(src[i]);
    dstBright[i] = (int) brightness(dst[i]);
  }
  println("precomputing brightness: " + tickTimer());
  
  for (int i = 0; i < n; i++) {
    float curBrightness = srcBright[i];
    for (int j = 0; j < n; j++) {
      int bin = (int) abs(curBrightness - dstBright[j]);
      bins[bin].add(new MatchPair(i, j));
    }
  }
  println("build bins: " + tickTimer());

  int[] positions = new int[n];
  boolean[] matchedSrc = new boolean[n], matchedDst = new boolean[n];
  println("allocated matches: " + tickTimer());

  for (int bin = 0; bin < binCount; bin++) {
    ArrayList all = bins[bin];
    for (int i = 0; i < all.size(); i++) {
      MatchPair cur = (MatchPair) all.get(i);
      int srcIndex = cur.src, dstIndex = cur.dst;
      // only use match if both objects are unmatched
      if (!matchedSrc[srcIndex] && !matchedDst[dstIndex]) {
        matchedSrc[srcIndex] = true;
        matchedDst[dstIndex] = true;
        positions[dstIndex] = srcIndex;
      }
    }
  }
  println("matched entries: " + tickTimer());

  return positions;
}

