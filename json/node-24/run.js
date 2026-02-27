// Taken from 
// Taken from https://github.com/kostya/benchmarks/blob/master/json/test.js

var jobj = (JSON.parse(require('fs').readFileSync("./sample.json", "utf8")));

var coordinates = jobj['coordinates'];
var len = coordinates.length;
var x = 0;
var y = 0;
var z = 0;

for (var i = 0; i < coordinates.length; i++) {
  coord = coordinates[i];
  x += coord['x'];
  y += coord['y'];
  z += coord['z'];
}

console.log(x / len);
console.log(y / len);
console.log(z / len);