var canvas, ctx,
  width, height,
  frameRate = 1000, frameCount = 0,
  mouseX = 0, mouseY = 0,
  fullscreen = false,
  stats, showStats = false;

window.addEventListener('load', loadEvent);
function loadEvent() {
  canvas = document.getElementById('Sketch');
  canvas.addEventListener('mousemove', mouseMoveEvent);
  canvas.addEventListener('click', mouseClickEvent);
  setupFullscreen();
  ctx = canvas.getContext('2d');
  width = canvas.width, height = canvas.height;
  setup();
  if(showStats) setupStats();
  loop();
}

function setupFullscreen() {
  var fullscreenBtn = document.getElementById("fullscreen-button");
  if(fullscreenBtn) {
    fullscreenBtn.addEventListener("click", function (evt) {
      if (canvas.requestFullscreen) {
        canvas.requestFullscreen();
      }
      else if (canvas.mozRequestFullScreen) {
        canvas.mozRequestFullScreen();
      }
      else if (canvas.webkitRequestFullScreen) {
        canvas.webkitRequestFullScreen();
      }
    }, false);
  }
  document.addEventListener("fullscreenchange", function(){fullscreenChangeEvent(document.fullscreen)}, false);
  document.addEventListener("mozfullscreenchange", function(){fullscreenChangeEvent(document.mozFullScreen)}, false);
  document.addEventListener("webkitfullscreenchange", function(){fullscreenChangeEvent(document.webkitIsFullScreen)}, false);
}

function fullscreenChangeEvent(fullscreen) {
  this.fullscreen = fullscreen;
  if(typeof fullscreenChange != 'undefined') fullscreenChange();
}

function findOffset(obj) {
  var curX = curY = 0;
  if (obj.offsetParent) {
    do {
      curX += obj.offsetLeft;
      curY += obj.offsetTop;
    } while (obj = obj.offsetParent);
  return {x:curX, y:curY};
  }
}

function mouseMoveEvent(e) {
  var offset = findOffset(canvas);
  mouseX = e.pageX - offset.x;
  mouseY = e.pageY - offset.y;
  if(typeof mouseMoved != 'undefined') mouseMoved();
}

function mouseClickEvent(e) {
  if(typeof mousePressed != 'undefined') mousePressed();
}

function loop() {
  requestAnimationFrame(loop);
  if(showStats) stats.begin();
  draw();
  if(showStats) stats.end();
  frameCount++;
}

function setupStats() {
  stats = new Stats();
  stats.setMode(0);
  stats.domElement.style.position = 'absolute';
  stats.domElement.style.top = '.5em';
  stats.domElement.style.left = '.5em';
  document.body.appendChild(stats.domElement);
}

function millis() {
  return Date.now();
}

function smoothStep(x) {
  return 3*(x*x)-2*(x*x*x);
}

function constrain(x, min, max) {
  if(x < min) return min;
  if(x > max) return max;
  return x;
}

function print(msg) {
  console.log(msg);
}

function dist(ax, ay, bx, by) {
  dx = bx - ax, dy = by - ay;
  return Math.sqrt(dx * dx + dy * dy);
}

function random(a, b) {
  if(typeof a === 'undefined') return Math.random();
  if(typeof b === 'undefined') return Math.random() * a;
  return Math.random() * (b - a) + a;
}

function pow(x, y) {
  return Math.pow(x, y);
}

function floor(x) {
  return x|0;
}

function lerp(start, end, amount) {
  return start + (end - start) * amount;
}

function abs(x) {
  return x < 0 ? -x : x;
}

function pick(x) {
  if(typeof x === 'undefined') return Math.random() > .5;
  var result = random(x)|0;
  return result < x ? result : x;
}

function rgb(brightness) {
  return 'rgb(' + brightness + ',' + brightness + ',' + brightness + ')';
}

function fill(brightness, ctx) {
  if(typeof ctx === 'undefined') ctx = this.ctx;
  brightness |= 0;
  ctx.strokeStyle = ctx.fillStyle = rgb(brightness);
}

function triangle(ax, ay, bx, by, cx, cy, ctx) {
  if(typeof ctx === 'undefined') ctx = this.ctx;
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

function createCanvas(width, height) {
  var canvas = document.createElement('canvas');
  canvas.width = width, canvas.height = height;
  return canvas;
}

function imageToRaw(src) {
  var canvas = imageToCanvas(src),
    imageData = getImageData(canvas);
  return imageData.data;
}

function imageToCanvas(src, width, height) {
  if(typeof width === 'undefined') width = src.width;
  if(typeof height === 'undefined') height = src.height;
  buffer = createCanvas(width, height);
  buffer.getContext('2d').drawImage(src, 0, 0, width, height);
  return buffer;
}

function getImageData(canvas) {
  return getContext(canvas).getImageData(0, 0, canvas.width, canvas.height);
}

function getContext(canvas) {
  return canvas.getContext('2d');
}

function background(brightness, ctx) {
  if(typeof ctx === 'undefined') ctx = this.ctx;
  ctx.save();
  ctx.fillStyle = rgb(brightness);
  ctx.fillRect(0, 0, width, height);
  ctx.restore();
}

// http://paulirish.com/2011/requestanimationframe-for-smart-animating/
(function() {
  var lastTime = 0;
  var vendors = ['ms', 'moz', 'webkit', 'o'];
  for(var x = 0; x < vendors.length && !window.requestAnimationFrame; ++x) {
    window.requestAnimationFrame = window[vendors[x]+'RequestAnimationFrame'];
    window.cancelAnimationFrame = 
      window[vendors[x]+'CancelAnimationFrame'] || window[vendors[x]+'CancelRequestAnimationFrame'];
  }

  if (!window.requestAnimationFrame) {
    window.requestAnimationFrame = function(callback, element) {
      var currTime = new Date().getTime();
      var timeToCall = Math.max(0, 16 - (currTime - lastTime));
      var id = window.setTimeout(function() { callback(currTime + timeToCall); }, 
        timeToCall);
      lastTime = currTime + timeToCall;
      return id;
    };
  }
  if (!window.cancelAnimationFrame) {
    window.cancelAnimationFrame = function(id) {clearTimeout(id)};
  }
}());