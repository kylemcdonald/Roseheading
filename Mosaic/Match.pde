void flatten(ArrayList[] nested, int[] flat) {
  int k = 0;
  for(int i = 0; i < nested.length; i++) {
    ArrayList cur = nested[i];
    //Collections.shuffle(cur);
    for(int j = 0; j < cur.size(); j++) {
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
  for(int i = 0; i < n; i++) {
    srcBins[int(brightness(src[i]))].add(i);
    dstBins[int(brightness(dst[i]))].add(i);
  }
  println(srcBins);
  int[] positions = new int[n];
  int[] flatSrc = new int[n];
  int[] flatDst = new int[n];
  flatten(srcBins, flatSrc);
  flatten(dstBins, flatDst);
  for(int i = 0; i < n; i++) {
    positions[flatDst[i]] = flatSrc[i];
  }
  /*
   for even better looking mosaics, after flatting these bins
   rearrange into equal-sized bins (e.g., for 32x32 elements,
   rearrange into 64 bins of size 16, or 128 bins of size 8)
   and then do a deep comparison to find the best match
   amongst the others in this bin. either check off matches
   as you go, or use the matching technique from Tracker to
   find an optimum.
  */
  return positions;
}

