int lastTime = millis();
int tickTimer() {
  int curTime = millis();
  int diff = curTime - lastTime;
  lastTime = curTime;
  return diff;
}

float smoothStep(float x) {
  return 3.*(x*x)-2.*(x*x*x);
}

color mean(PImage src, int x, int y, int w, int h) {
  float[] sum = new float[3];
  int i = y * src.width + x;
  for(int j = 0; j < h; j++) {
    for(int k = 0; k < w; k++) {
      color cur = src.pixels[i];
      sum[0] += red(cur);
      sum[1] += green(cur);
      sum[2] += blue(cur);
      i++;
    }
    i += src.width - w;
  }
  int n = w * h;
  return color(sum[0] / n, sum[1] / n, sum[2] / n);
}

void resizeArea(PImage src, PImage dst) {
  int sw = src.width, sh = src.height;
  int dw = dst.width, dh = dst.height;
  int w = sw / dw, h = sh / dh;
  for(int y = 0; y < dh; y++) {
    for(int x = 0; x < dw; x++) {
      dst.set(x, y, mean(src, x * w, y * h, w, h));
    }
  }
}
