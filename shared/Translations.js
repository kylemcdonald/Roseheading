var translationLatin = ["datu","verilənlər","podatak","dada","datumo","datu","donnée","podatak","dato","gögn","dati","duomenys","adat","gegeven","dados","dată","podatek","podatak","datos","veri","dữ liệu"];
var translationOther = ["δεδομένα","даныя","данни","数据","데이터","بيانات","উপাত্ত","داده","дерек","נתונים","берилиштер","податок","विदा","データ","ыҥпале","дата","данные","اعداد","دراوە","податак","தரவு","ข้อมูล","дані","معطیات","数据","דאטן"];
var baseTranslation = "data";

function randomTranslation() {
  var mode = random(5);
  if(mode < 3) return translationOther[pick(translationOther.length)];
  if(mode < 4) return translationLatin[pick(translationLatin.length)];
  return baseTranslation;
}

function setupText(ctx) {
  if(typeof ctx === 'undefined') ctx = this.ctx;
  ctx.font = '100px sans-serif';
  ctx.textAlign = 'center';
  ctx.textBaseline = 'middle';
}

function drawCenteredText(text, textWidth, ctx) {
  if(typeof ctx === 'undefined') ctx = this.ctx;
  var metrics = ctx.measureText(text);
  var scale = textWidth / metrics.width;
  ctx.save();
  ctx.translate(width / 2, height / 2);
  ctx.scale(scale, scale);
  ctx.fillText(text, 0, 0);
  ctx.restore();
}