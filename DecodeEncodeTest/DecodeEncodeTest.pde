void setup() {
  size(256, 256);
  PImage img = loadImage("gpunoise.png");
  encode(img);
  //decode(img);
  img.save("encoded.png");
  image(img, 0, 0);
}

void encode(PImage img) {
  for (int i = 0; i < 256*256; i++) {
    color cur = img.pixels[i];
    int r = int(red(cur));
    int g = int(green(cur));
    int b = int(blue(cur));
    int k = i % 256;
    r = k^flipnib(k^flipopp(k^r));
    g = k^flipnib(k^flipopp(k^g));
    b = k^flipnib(k^flipopp(k^b));
    img.pixels[i] = color(r, g, b);
  }
}

void decode(PImage img) {
  for (int i = 0; i < 256*256; i++) {
    color cur = img.pixels[i];
    int k = i % 256;
    int r = int(red(cur));
    int g = int(green(cur));
    int b = int(blue(cur));
    r = k^flipopp(k^flipnib(k^r));
    g = k^flipopp(k^flipnib(k^g));
    b = k^flipopp(k^flipnib(k^b));
    img.pixels[i] = color(r, g, b);
  }
}

int flipnib(int x) {return ((x&15)<<4)|((x&240)>>4);}
int flipopp(int x) {return ((x&170)>>1)|((x&85)<<1);}
