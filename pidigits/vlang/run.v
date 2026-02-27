import math.big
import os

fn main() {
	n := if os.args.len > 1 { os.args[1].int() } else { 10000 }

	mut q := big.integer_from_int(1)
	mut r := big.integer_from_int(0)
	mut t := big.integer_from_int(1)
	mut k := big.integer_from_int(1)
	mut nd := big.integer_from_int(3)
	mut l := big.integer_from_int(3)

	ten := big.integer_from_int(10)
	two := big.integer_from_int(2)
	three := big.integer_from_int(3)
	four := big.integer_from_int(4)
	seven := big.integer_from_int(7)

	mut count := 0
	mut buf := ''

	for count < n {
		if four * q + r - t < nd * t {
			buf += nd.str()
			count++
			if count % 10 == 0 {
				buf += '\t:${count}\n'
			}
			nr := ten * (r - nd * t)
			nd = ten * (three * q + r) / t - ten * nd
			q = q * ten
			r = nr
		} else {
			nr := (two * q + r) * l
			nn := (q * (seven * k + two) + r * l) / (t * l)
			q = q * k
			t = t * l
			l = l + two
			k = k + big.integer_from_int(1)
			nd = nn
			r = nr
		}
	}

	if count % 10 != 0 {
		spaces := 10 - count % 10
		for _ in 0 .. spaces {
			buf += ' '
		}
		buf += '\t:${count}\n'
	}
	print(buf)
}
