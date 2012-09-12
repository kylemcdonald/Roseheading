var translationLatin = ["adatok","andmed","dades","dados","Daten","dati","datos","datu","données","gegevens","podatkov","tiedot","údaje","veri"];
var translationOther = ["dữ liệu","duomenų","údaje","البيانات","δεδομένα","дані","данни","данные","נתונים","داده ها","डेटा","ข้อมูล","데이터","データ","数据"];
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