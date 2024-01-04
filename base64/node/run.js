var MD5 = require('md5.js')

var STR_SIZE = 1000000;
var TRIES = 20;

function md5(str) {
  return new MD5().update(str).digest('hex');
}

var str = ""; for (var i = 0; i < STR_SIZE; i++) str += "a";
console.log(md5(str));

for (var i = 0; i < TRIES; i++) {
  var b = Buffer.from(str);
  str = b.toString('base64');
}
console.log(md5(str));

for (var i = 0; i < TRIES; i++) {
  var b = Buffer.from(str, 'base64');
  var str = b.toString();
}
console.log(md5(str));
