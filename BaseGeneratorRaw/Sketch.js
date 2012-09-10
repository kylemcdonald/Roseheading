var files = [
  "data/pdfglitch.png", 
  "data/building.png", 
  "data/bytebeat.png", 
  "data/cmdtab.png", 
  "data/gpunoise.png", 
  "data/infinitefill.png", 
  "data/interface.png", 
  "data/stacks.png", 
  "data/street.png"
];
var images = loadImages(files);

function setup() {
  frameRate = 1;//60;
  setupBaseGenerator();
}

function draw() {
  buildTriangleField(base, 255, 128);
}

var base, regionMap, modeMap;
function setupBaseGenerator() {
  base = createCanvas(width, height);
  regionMap = createCanvas(width, height);
  modeMap = createCanvas(width, height);
}

function generateBase() {
  passes = pick(4);
}

function createSingle() {
  regionScale = random(32, 1024);
  modeScale = random(16, 64);
  buildTriangleField(regionMap, images.length, regionScale);
}

function buildTriangleField(canvas, levels, side) {
  var ctx = getContext(canvas);
  ox = -random(side), oy = -random(side);
  py = oy, y = oy;
  var nwx, nwy, nex, ney, swx, swy, sex, sey;
  while(py < height) {
    px = ox, x = ox;
    y += side;
    while(px < width) {
      px = x;
      x += side;
      off = pick() ? 0 : random(side / 4);
      if(pick()) {
        fill(pick(levels), ctx);
        triangle(px, py, px - off, y + off, x, py, ctx);
        fill(pick(levels), ctx);
        triangle(x, py, x, y, px - off, y + off, ctx);
      } else {
        fill(pick(levels), ctx);
        triangle(px - off, py - off, px, y, x, y, ctx);
        fill(pick(levels), ctx);
        triangle(x, py, x, y, px - off, py - off, ctx);
      }
    }
    py = y;
  }
}