import { createHash } from "crypto";

const STR_SIZE = 1000000;
const TRIES = 20;

function md5hex(data: string | Buffer): string {
  return createHash("md5").update(data).digest("hex");
}

let str = "a".repeat(STR_SIZE);
console.log(md5hex(str));

for (let i = 0; i < TRIES; i++) {
  str = Buffer.from(str).toString("base64");
}
console.log(md5hex(str));

for (let i = 0; i < TRIES; i++) {
  str = Buffer.from(str, "base64").toString();
}
console.log(md5hex(str));
