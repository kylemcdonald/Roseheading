void flatten(ArrayList[] nested, int[] flat) {
  int k = 0;
  for (int i = 0; i < nested.length; i++) {
    ArrayList cur = nested[i];
    //Collections.shuffle(cur);
    for (int j = 0; j < cur.size(); j++) {
      flat[k] = (Integer) cur.get(j);
      k++;
    }
  }
}

float distance(PImage a, PImage b) {
  int[] ap = a.pixels, bp = b.pixels;
  int n = ap.length;
  float sum = 0;
  for(int i = 0; i < n; i++) {
    sum +=
      abs(red(ap[i]) - red(bp[i])) +
      abs(green(ap[i]) - green(bp[i])) +
      abs(blue(ap[i]) - blue(bp[i]));
  }
  return sum;
}

float distance(int baseIndex, int targetIndex) {
  return distance(baseChop[baseIndex], targetChop[targetIndex]); 
}

boolean refine = false;
int refineDistance = 8;

int binCount = 256;
int[] findMosaic(PImage srcImg, PImage dstImg) {
  int n = srcImg.width * srcImg.height;
  color[] src = srcImg.pixels, dst = dstImg.pixels;
  ArrayList[] srcBins = new ArrayList[binCount];
  ArrayList[] dstBins = new ArrayList[binCount];
  for (int i = 0; i < binCount; i++) {
    srcBins[i] = new ArrayList();
    dstBins[i] = new ArrayList();
  }
  for (int i = 0; i < n; i++) {
    srcBins[int(brightness(src[i]))].add(i);
    dstBins[int(brightness(dst[i]))].add(i);
  }
  int[] positions = new int[n];
  int[] flatSrc = new int[n];
  int[] flatDst = new int[n];
  flatten(srcBins, flatSrc);
  flatten(dstBins, flatDst);

  if (!refine) {
    for (int i = 0; i < n; i++) {
      positions[flatDst[i]] = flatSrc[i];
    }
  } else {
    boolean[] taken = new boolean[n];
    for (int i = 0; i < n; i++) {
      int srcIndex = flatSrc[i];
      float best = MAX_FLOAT;
      int bestIndex = 0;
      int left = max(0, i - refineDistance);
      int right = min(i + refineDistance, n);
      for (int j = left; j < right; j++) {
        if (i != j && !taken[j]) {
          int dstIndex = flatDst[j];
          float cur = distance(srcIndex, dstIndex);
          if (cur < best) {
            best = cur;
            bestIndex = j;
          }
        }
      }
      taken[bestIndex] = true;
      int dstIndex = flatDst[bestIndex];
      positions[dstIndex] = srcIndex;
    }
  }
  
  return positions;
}

