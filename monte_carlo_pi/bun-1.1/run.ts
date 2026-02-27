function approxPi(throws: number): number {
  let inside = 0;
  for (let i = 0; i < throws; i++) {
    const x = Math.random();
    const y = Math.random();
    if (Math.hypot(x, y) <= 1.0) {
      inside++;
    }
  }
  return 4.0 * inside / throws;
}

for (const n of [1000, 10000, 100000, 1000000, 10000000]) {
  console.log(`${String(n).padStart(8)} samples: PI = ${approxPi(n)}`);
}
