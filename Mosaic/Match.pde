class MatchPair {
  int src, dst;
}

float trackingDistance(color a, color b) {
  float sum =
    abs(brightness(a) - brightness(b)) +
    abs(saturation(a) - saturation(b)) +
    abs(hue(a) - hue(b));
  return sum / 3;
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

  for (int i = 0; i < n; i++) {
    for (int j = 0; j < n; j++) {
      MatchPair cur = new MatchPair();
      cur.src = i;
      cur.dst = j;
      int bin = (int) trackingDistance(src[i], dst[j]);
      bins[bin].add(cur);
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

