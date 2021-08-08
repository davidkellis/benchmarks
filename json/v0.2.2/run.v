import json
import os

struct Coordinate {
	x f64
	y f64
	z f64
}

struct TestStruct {
	coordinates []Coordinate
}

fn main() {
	file_contents := os.read_file("./sample.json") or { panic(err) }

	jobj := json.decode(TestStruct, file_contents) or { panic(err) }

	mut x, mut y, mut z := 0.0, 0.0, 0.0

	for coord in jobj.coordinates {
		x += coord.x
		y += coord.y
		z += coord.z
	}

	len := f64(jobj.coordinates.len)
	println("${(x/len):.8f}")
	println("${(y/len):.8f}")
	println("${(z/len):.8f}")
}
