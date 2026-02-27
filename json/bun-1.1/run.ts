const file = Bun.file("./sample.json");
const jobj = await file.json();

const coordinates = jobj['coordinates'];
const len = coordinates.length;
let x = 0;
let y = 0;
let z = 0;

for (let i = 0; i < coordinates.length; i++) {
  const coord = coordinates[i];
  x += coord['x'];
  y += coord['y'];
  z += coord['z'];
}

console.log(x / len);
console.log(y / len);
console.log(z / len);
