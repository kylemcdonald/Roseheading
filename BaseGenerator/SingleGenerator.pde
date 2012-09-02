PImage createBase(int alphaValue) {
  PImage base = createImage(width, height, ARGB);
  
  float regionScale = random(32, 1024), modeScale = random(16, 64);
  buildMap(regionMap, images.length, int(regionScale), int(-random(regionScale)), int(-random(regionScale)));
  regionMap.loadPixels();
  buildMap(modeMap, 255, int(modeScale), int(-random(modeScale)), int(-random(modeScale)));
  modeMap.loadPixels();

  int alphaMask = color(255, alphaValue);
  int m = 512 * 512;
  int n = width * height;
  int j = 0;
  int prevChoice = 0;
  
  base.loadPixels();
  int zoomBase = int(random(2, 32));
  int zoom = 1;
  boolean badSync = random(2) > 1;
  for (int i = 0; i < n; ++i) {
    int curChoice = regionMap.pixels[i] & 0xff;
    if(badSync) {
      if(i % zoom == 0) {
        ++j;
      }
    } else {
      if(((i % width) % zoom) == 0) {
        ++j;
      }
    }
    if (curChoice != prevChoice) {
      int curMode = modeMap.pixels[i] & 0xff;
      boolean verticalSync = (curMode & 1) > 0;
      boolean horizontalSync = (curMode & 2) > 0;
      boolean firstLineOnly = (curMode & 4) > 0;
      zoom = (curMode & 8) > 0 ? zoomBase : 1;
      if (firstLineOnly) {
        j = 0;
      }
      if (verticalSync) {
        j = int(int(i / width) / zoom) * 512;
      }
      if (horizontalSync) {
        j += (i % width);
      }
    }
    j %= m;
    base.pixels[i] = images[curChoice].pixels[j] & alphaMask;
    prevChoice = curChoice;
  }
  base.updatePixels();
  
  return base;
}
