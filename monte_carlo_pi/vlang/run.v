import math
import rand

fn approx_pi(throws int) f64 {
	mut inside := 0
	for _ in 0 .. throws {
		x := rand.f64()
		y := rand.f64()
		if math.hypot(x, y) <= 1.0 {
			inside++
		}
	}
	return 4.0 * f64(inside) / f64(throws)
}

fn main() {
	for n in [1000, 10000, 100000, 1000000, 10000000] {
		println('${n:8d} samples: PI = ${approx_pi(n)}')
	}
}
