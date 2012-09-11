function setup() {
  frameRate = 60;
}

function draw() {
  ctx.clearRect(0, 0, width, height);
  ctx.fillRect(mouseX - 50, mouseY - 50, 100, 100);
}

function mouseMoved() {
  print(mouseX + " " + mouseY);
}