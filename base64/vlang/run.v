import encoding.base64
import crypto.md5

fn md5hex(data string) string {
	sum := md5.sum(data.bytes())
	mut result := ''
	for b in sum {
		result += '${b:02x}'
	}
	return result
}

fn main() {
	str_size := 1000000
	tries := 20

	mut str := 'a'.repeat(str_size)
	println(md5hex(str))

	for _ in 0 .. tries {
		str = base64.encode_str(str)
	}
	println(md5hex(str))

	for _ in 0 .. tries {
		str = base64.decode_str(str)
	}
	println(md5hex(str))
}
