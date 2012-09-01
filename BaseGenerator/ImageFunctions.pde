color saturate(color c, float pump) {
  float curSaturation = saturation(c);
  if(curSaturation == 0) {
    return c;
  }
  float bright = brightness(c);
  float hueSix = hue(c) * 6. / 255;
  int hueSixCategory = int(hueSix);
  float hueSixRemainder = hueSix - hueSixCategory;
  float saturationNorm = min(1, curSaturation / 255 + pump);
  float pv = ((1 - saturationNorm) * bright);
  float qv = ((1 - saturationNorm * hueSixRemainder) * bright);
  float tv = ((1 - saturationNorm * (1 - hueSixRemainder)) * bright);
  switch(hueSixCategory) {
    case 0: return color(bright, tv, pv);
    case 1: return color(qv, bright, pv);
    case 2: return color(pv, bright, tv);
    case 3: return color(pv, qv, bright);
    case 4: return color(tv, pv, bright);
    default: return color(bright, pv, qv);
  }
}

void saturate() {
  int n = width * height;
  loadPixels();
  for (int i = 0; i < n; i++) {
    pixels[i] = saturate(pixels[i], 1);
  }
  updatePixels();
}

