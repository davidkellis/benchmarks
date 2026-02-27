import os

fn matgen(n int) [][]f64 {
	tmp := 1.0 / f64(n) / f64(n)
	mut a := [][]f64{len: n, init: []f64{len: n}}
	for i in 0 .. n {
		for j in 0 .. n {
			a[i][j] = tmp * f64(i - j) * f64(i + j)
		}
	}
	return a
}

fn matmul(a [][]f64, b [][]f64, n int) [][]f64 {
	// transpose
	mut bt := [][]f64{len: n, init: []f64{len: n}}
	for i in 0 .. n {
		for j in 0 .. n {
			bt[i][j] = b[j][i]
		}
	}
	mut c := [][]f64{len: n, init: []f64{len: n}}
	for i in 0 .. n {
		for j in 0 .. n {
			mut s := 0.0
			for k in 0 .. n {
				s += a[i][k] * bt[j][k]
			}
			c[i][j] = s
		}
	}
	return c
}

fn main() {
	mut n := 100
	if os.args.len > 1 {
		n = os.args[1].int()
	}
	n = n / 2 * 2
	a := matgen(n)
	b := matgen(n)
	c := matmul(a, b, n)
	println(c[n / 2][n / 2])
}
