color saturate(color c, int mode) {
  float curSaturation = saturation(c);
  if(curSaturation == 0) {
    return c;
  }
  float bright = brightness(c);
  float hueSix = hue(c) * 6 / 255;
  int hueSixCategory = int(hueSix);
  if(mode < 10) {
    float hueSixRemainder = hueSix - hueSixCategory;
    float saturationNorm = mode / 10.;
    float pv = ((1 - saturationNorm) * bright);
    float qv = ((1 - saturationNorm * hueSixRemainder) * bright);
    float tv = ((1 - saturationNorm * (1 - hueSixRemainder)) * bright);
    switch(hueSixCategory) {
      case 0: return color(bright, tv, pv); // r
      case 1: return color(qv, bright, pv); // g
      case 2: return color(pv, bright, tv); // g
      case 3: return color(pv, qv, bright); // b
      case 4: return color(tv, pv, bright); // b
      default: return color(bright, pv, qv); // r
    }
  } else {
    switch(hueSixCategory) {
      case 0: return color(bright, 0, 0); // r
      case 1: return color(255, bright, 0); // g
      case 2: return color(0, bright, 0); // g
      case 3: return color(255, 0, bright); // b
      case 4: return color(0, 0, bright); // b
      default: return color(bright, 255, 0); // r
    }
  }
}

void saturate() {
  buildMap(saturateMap, 20, int(random(1, 8) * 128));
  
  int n = width * height;
  loadPixels();
  for (int i = 0; i < n; i++) {
    pixels[i] = saturate(pixels[i], saturateMap.pixels[i] & 0xff);
  }
  updatePixels();
}

