// Taken from https://github.com/kostya/benchmarks/blob/master/base64/Base64Java.java

import java.util.Base64;
import static java.lang.System.out;
import static java.nio.charset.StandardCharsets.ISO_8859_1;

class base64 {

	final static int STR_SIZE = 10000000;
	final static int TRIES = 100;

	final static Base64.Decoder dec = Base64.getDecoder();
	final static Base64.Encoder enc = Base64.getEncoder();

	public static void main(String[] args) {

		StringBuilder sb = new StringBuilder("");
		for (int i = 0; i < STR_SIZE; i++) {
			sb.append("a");
		}
		String str = sb.toString();
		String str2 = "";
		String str3;

		int s = 0;
		Long t = System.nanoTime();
		for (int i = 0; i < TRIES; i++) {
			str2 = enc.encodeToString(str.getBytes(ISO_8859_1));
			s += str2.length();
		}
		out.println("encode: " + s + ", " + (System.nanoTime() - t) / 1e9);

		s = 0;
		t = System.nanoTime();
		for (int i = 0; i < TRIES; i++) {
			byte[] b_arr = dec.decode(str2.getBytes(ISO_8859_1));
			str3 = new String(b_arr, ISO_8859_1);
			s += str3.length();
		}
		out.println("decode: " + s + ", " + (System.nanoTime() - t) / 1e9);
	}
}