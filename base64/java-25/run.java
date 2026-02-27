// Taken from https://github.com/kostya/benchmarks/blob/master/base64/Base64Java.java

import java.util.Base64;
import static java.lang.System.out;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

class run {
	final static int STR_SIZE = 1000000;
	final static int TRIES = 20;

	final static Base64.Decoder dec = Base64.getDecoder();
	final static Base64.Encoder enc = Base64.getEncoder();

	static String hexDigest(String str, String digestName) {
		try {
			MessageDigest md = MessageDigest.getInstance(digestName);
			byte[] digest = md.digest(str.getBytes(StandardCharsets.UTF_8));
			char[] hex = new char[digest.length * 2];
			for (int i = 0; i < digest.length; i++) {
				hex[2 * i] = "0123456789abcdef".charAt((digest[i] & 0xf0) >> 4);
				hex[2 * i + 1] = "0123456789abcdef".charAt(digest[i] & 0x0f);
			}
			return new String(hex);
		} catch (NoSuchAlgorithmException e) {
			throw new IllegalStateException(e);
		}
	}

	public static void main(String[] args) {
		StringBuilder sb = new StringBuilder("");
		for (int i = 0; i < STR_SIZE; i++) {
			sb.append("a");
		}
		String str = sb.toString();
		out.println(hexDigest(str, "MD5"));

		for (int i = 0; i < TRIES; i++) {
			str = enc.encodeToString(str.getBytes(StandardCharsets.ISO_8859_1));
		}
		out.println(hexDigest(str, "MD5"));

		for (int i = 0; i < TRIES; i++) {
			byte[] b_arr = dec.decode(str.getBytes(StandardCharsets.ISO_8859_1));
			str = new String(b_arr, StandardCharsets.ISO_8859_1);
		}
		out.println(hexDigest(str, "MD5"));
	}
}