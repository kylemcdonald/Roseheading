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
  for (int i = 0; i < n; i++) {
    positions[flatDst[i]] = flatSrc[i];
  }
  return positions;
}

