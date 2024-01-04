const file = Bun.file("./sample.json");
const jobj = await file.json();

var coordinates = jobj['coordinates'];
var len = coordinates.length;
var x = 0;
var y = 0;
var z = 0;

for (var i = 0; i < coordinates.length; i++) {
  var coord = coordinates[i];
  x += coord['x'];
  y += coord['y'];
  z += coord['z'];
}

console.log(x / len);
console.log(y / len);
console.log(z / len);
