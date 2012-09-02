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
  color out;
  switch(hueSixCategory) {
    case 0: out = color(bright, tv, pv); break; // r
    case 1: out = color(qv, bright, pv); break; // g
    case 2: out = color(pv, bright, tv); break; // g
    case 3: out = color(pv, qv, bright); break; // b
    case 4: out = color(tv, pv, bright); break; // b
    default: out = color(bright, pv, qv); break; // r
  }
  return out;
  /*
  switch(hueSixCategory) {
    case 0: out = color(bright, 0, 0); break; // r
    case 1: out = color(255, bright, 0); break; // g
    case 2: out = color(0, bright, 0); break; // g
    case 3: out = color(255, 0, bright); break; // b
    case 4: out = color(0, 0, bright); break; // b
    default: out = color(bright, 255, 0); break; // r
  }*/
}

void saturate(float amt) {
  int n = width * height;
  loadPixels();
  for (int i = 0; i < n; i++) {
    pixels[i] = saturate(pixels[i], amt);
  }
  updatePixels();
}

