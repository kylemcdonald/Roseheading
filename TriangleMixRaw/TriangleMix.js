var canvas, ctx;
var width, height;
var interval;
var frameRate = 1000, frameCount = 0;

function init() {
  canvas = document.getElementById("TriangleMix");
  ctx = canvas.getContext("2d");
  width = canvas.width, height = canvas.height;
  setup();
  interval = setInterval(
    function() {
      draw();
      frameCount++
    }, 1000 / frameRate);
}

function print(msg) {
  document.getElementById("debug").innerHTML = msg;
}

function random(a, b) {
  if(typeof(a)==='undefined') return Math.random();
  if(typeof(b)==='undefined') return Math.random() * a;
  return Math.random() * (b - a) + a;
}

function pick(x) {
  if(typeof(x)==='undefined') return Math.random() > .5;
  else return random(x);
}

function fill(brightness) {
  brightness |= 0;
  ctx.fillStyle = 'rgba(' + brightness + ',' + brightness + ',' + brightness + ', 255)';
}

function triangle(ax, ay, bx, by, cx, cy) {
  ctx.beginPath();
  ctx.moveTo(ax|0, ay|0);
  ctx.lineTo(bx|0, by|0);
  ctx.lineTo(cx|0, cy|0);
  ctx.fill();
  ctx.closePath();
}

// - - --

var stats;
function setupStats() {
  stats = new Stats();
  stats.setMode(0);
  stats.domElement.style.position = 'absolute';
  stats.domElement.style.left = '0px';
  stats.domElement.style.top = '0px';
  document.body.appendChild(stats.domElement);
}

function setup() {
  frameRate = 1;//60;
  setupStats();
}

function draw() {
  stats.begin();
  
  levels = 255;
  side = random(16, 256);
  ox = -random(side), oy = -random(side);
  py = oy, y = oy;
  while(py < height) {
    px = ox, x = ox;
    y += side;
    while(px < width) {
      px = x;
      x += side;
      off = pick() ? 0 : random(side / 4);
      if(pick()) {
        fill(pick(levels));
        triangle(px, py, px - off, y + off, x, py);
        fill(pick(levels));
        triangle(x, py, x, y, px - off, y + off);
      } else {
        fill(pick(levels));
        triangle(px - off, py - off, px, y, x, y);
        fill(pick(levels));
        triangle(x, py, x, y, px - off, py - off);
      }
    }
    py = y;
  }
  
  stats.end();
}