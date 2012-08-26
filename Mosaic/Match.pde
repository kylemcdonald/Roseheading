void flatten(ArrayList[] nested, int[] flat) {
  int k = 0;
  for(int i = 0; i < nested.length; i++) {
    ArrayList cur = nested[i];
    for(int j = 0; j < cur.size(); j++) {
      flat[k] = (Integer) cur.get(j);
      k++;
    }
  }
}

int[] findMosaic(PImage srcImg, PImage dstImg) {
  int w = srcImg.width, h = srcImg.height;
  int n = w * h, n2 = n * n;

  color[] src = srcImg.pixels, dst = dstImg.pixels;

  tickTimer();  
  int binCount = 256;
  ArrayList[] srcBins = new ArrayList[binCount];
  ArrayList[] dstBins = new ArrayList[binCount];
  for (int i = 0; i < binCount; i++) {
    srcBins[i] = new ArrayList();
    dstBins[i] = new ArrayList();
  }
  println("allocating bins: " + tickTimer());

  for(int i = 0; i < n; i++) {
    int srcBright = int(brightness(src[i]));
    int dstBright = int(brightness(dst[i]));
    srcBins[srcBright].add(i);
    dstBins[dstBright].add(i);
  }
  println("filling bins: " + tickTimer());
  
  int[] positions = new int[n];
  int[] flatSrc = new int[n];
  int[] flatDst = new int[n];
  flatten(srcBins, flatSrc);
  flatten(dstBins, flatDst);
  for(int i = 0; i < n; i++) {
    positions[flatDst[i]] = flatSrc[i];
  }

  println("matched entries: " + tickTimer());

  return positions;
}

