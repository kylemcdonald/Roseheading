function setup() {
  ctx.font = '150px sans-serif';
  textAlign('center', 'middle');
}

function draw() {
  str = "ข้อมูล";
  metrics = ctx.measureText(str);
  ctx.fillText(str, width / 2, height / 2);
}