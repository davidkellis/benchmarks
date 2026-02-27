function matgen(n: number): Float64Array[] {
  const tmp = 1.0 / n / n;
  const a: Float64Array[] = [];
  for (let i = 0; i < n; i++) {
    a[i] = new Float64Array(n);
    for (let j = 0; j < n; j++) {
      a[i][j] = tmp * (i - j) * (i + j);
    }
  }
  return a;
}

function matmul(a: Float64Array[], b: Float64Array[], n: number): Float64Array[] {
  const c: Float64Array[] = [];
  // transpose b
  const bt: Float64Array[] = [];
  for (let i = 0; i < n; i++) {
    bt[i] = new Float64Array(n);
    for (let j = 0; j < n; j++) {
      bt[i][j] = b[j][i];
    }
  }
  for (let i = 0; i < n; i++) {
    c[i] = new Float64Array(n);
    for (let j = 0; j < n; j++) {
      let sum = 0;
      for (let k = 0; k < n; k++) {
        sum += a[i][k] * bt[j][k];
      }
      c[i][j] = sum;
    }
  }
  return c;
}

let n = 100;
if (process.argv.length > 2) n = parseInt(process.argv[2]);
if (Bun.argv.length > 2) n = parseInt(Bun.argv[2]);
n = Math.floor(n / 2) * 2;
const a = matgen(n);
const b = matgen(n);
const d = matmul(a, b, n);
console.log(d[n / 2][n / 2]);
