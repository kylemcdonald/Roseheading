class MatchPair implements Comparable {
  int src, dst;
  float distance;
  
  int compareTo(Object obj) {
    MatchPair other = (MatchPair) obj;
    if(other.distance > distance) {
      return -1;
    } if(other.distance == distance) {
      return 0;
    } else {
      return +1;
    }
  }
}

float trackingDistance(color a, color b) {
  return abs(brightness(a) - brightness(b));
}

int[] findMosaic(PImage srcImg, PImage dstImg) {
  int w = srcImg.width, h = srcImg.height;
  int n = w * h, n2 = n * n;

  color[] src = srcImg.pixels, dst = dstImg.pixels;

  MatchPair[] all= new MatchPair[n2];
  int k = 0;
  println("building distance matrix");
  for (int i = 0; i < n; i++) {
    for (int j = 0; j < n; j++) {
      all[k] = new MatchPair();
      all[k].src = i;
      all[k].dst = j;
      all[k].distance = trackingDistance(src[i], dst[j]);
      k++;
    }
  }

  // todo: sort by binned distances, Comparable is not js-friendly
  // don't sort after the fact, just bin in advance
  println("sorting matrix");
  Arrays.sort(all);

  int[] positions = new int[n];
  boolean[] matchedSrc = new boolean[n], matchedDst = new boolean[n];
  
  // walk through matches in order
  for (int i = 0; i < n2; i++) {
    int srcIndex = all[i].src, dstIndex = all[i].dst;
    // only use match if both objects are unmatched
    if (!matchedSrc[srcIndex] && !matchedDst[dstIndex]) {
      matchedSrc[srcIndex] = true;
      matchedDst[dstIndex] = true;
      positions[dstIndex] = srcIndex;
    }
  }

  return positions;
}
