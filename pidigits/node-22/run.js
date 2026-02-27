const n = parseInt(process.argv[2] || "10000");

let q = 1n, r = 0n, t = 1n, k = 1n, nd = 3n, l = 3n;
let count = 0;
const parts = [];

while (count < n) {
  if (4n * q + r - t < nd * t) {
    parts.push(nd.toString());
    count++;
    if (count % 10 === 0) parts.push(`\t:${count}\n`);
    const nr = 10n * (r - nd * t);
    nd = 10n * (3n * q + r) / t - 10n * nd;
    q *= 10n;
    r = nr;
  } else {
    const nr = (2n * q + r) * l;
    const nn = (q * (7n * k + 2n) + r * l) / (t * l);
    q *= k;
    t *= l;
    l += 2n;
    k += 1n;
    nd = nn;
    r = nr;
  }
}
if (count % 10 !== 0) {
  parts.push(" ".repeat(10 - count % 10) + `\t:${count}\n`);
}
process.stdout.write(parts.join(""));
