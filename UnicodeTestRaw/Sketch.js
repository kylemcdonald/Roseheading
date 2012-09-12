var translationLatin = ["datu","verilənlər","podatak","dada","datumo","datu","donnée","podatak","dato","gögn","dati","duomenys","adat","gegeven","dados","dată","podatek","podatak","datos","veri","dữ liệu"];
var translationOther = ["δεδομένα","даныя","данни","数据","데이터","بيانات","উপাত্ত","داده","дерек","נתונים","берилиштер","податок","विदा","データ","ыҥпале","дата","данные","اعداد","دراوە","податак","தரவு","ข้อมูล","дані","معطیات","数据","דאטן"];

function randomTranslation() {
  var mode = random(5);
  if(mode < 3) return translationOther[pick(translationOther.length)];
  if(mode < 4) return translationLatin[pick(translationLatin.length)];
  return "data";
}

function setup() {
  frameRate = 2;
  setupText();
}

function draw() {
  background();
  drawCenteredText(randomTranslation(), 750);
}