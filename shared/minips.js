var canvas, ctx;
var width, height;
var interval;
var frameRate = 1000, frameCount = 0;

window.addEventListener("load", init);
function init() {
  canvas = document.getElementById("Sketch");
  ctx = canvas.getContext("2d");
  width = canvas.width, height = canvas.height;
  setupStats();
  setup();
  interval = setInterval(loop, 1000 / frameRate);
}

function loop() {
  stats.begin();
  draw();
  stats.end();
  frameCount++
}

var stats;
function setupStats() {
  stats = new Stats();
  stats.setMode(0);
  stats.domElement.style.position = 'absolute';
  stats.domElement.style.top = '.5em';
  stats.domElement.style.left = '.5em';
  document.body.appendChild(stats.domElement);
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
  return random(x);
}

function fill(brightness) {
  brightness |= 0;
  ctx.strokeStyle = ctx.fillStyle = 'rgb(' + brightness + ',' + brightness + ',' + brightness + ')';
}

function triangle(ax, ay, bx, by, cx, cy) {
  ctx.beginPath();
  ctx.moveTo(ax|0, ay|0);
  ctx.lineTo(bx|0, by|0);
  ctx.lineTo(cx|0, cy|0);
  ctx.fill();
  ctx.stroke();
  ctx.closePath();
}

function loadImages(files) {
  var images = new Array();
  for(i in files) {
    var image = new Image();
    image.src = files[i];
    images.push(image);
  }
  return images;
}