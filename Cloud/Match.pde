class MatchPosition implements Comparable {
  int position;
  color c;
  MatchPosition(int position, color c) {
    this.position = position;
    this.c = c;
  }  
  int compareTo(Object o) {
    float b1 = brightness(c);
    float b2 = brightness(((MatchPosition) o).c);
    if (b1 < b2) {
      return -1;
    } 
    else if (b1 == b2) {
      float s1 = saturation(c), s2 = saturation(((MatchPosition) o).c);
      if(s1 < s2) {
        return -1;
      } else if(s1 == s2) {
        return 0;
      } else {
        return +1;
      }
    } 
    else {
      return +1;
    }
  }
};

void flatten(ArrayList[] nested, int[] flat) {
  int k = 0;
  for (int i = 0; i < nested.length; i++) {
    ArrayList cur = nested[i];
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

  /*
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
   */

  ArrayList flatSrc = new ArrayList();
  ArrayList flatDst = new ArrayList();
  for (int i = 0; i < n; i++) {
    flatSrc.add(new MatchPosition(i, src[i]));
    flatDst.add(new MatchPosition(i, dst[i]));
  }
  Collections.sort(flatSrc);
  Collections.sort(flatDst);
  int[] positions = new int[n];
  for (int i = 0; i < n; i++) {
    positions[((MatchPosition) flatDst.get(i)).position] = ((MatchPosition) flatSrc.get(i)).position;
  }

  return positions;
}

