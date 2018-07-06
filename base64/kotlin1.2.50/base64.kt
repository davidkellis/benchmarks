// Taken from https://github.com/kostya/benchmarks/blob/master/base64/Test.kt

import java.util.Base64
import java.security.MessageDigest

val STR_SIZE = 1000000
val TRIES = 20

val enc = Base64.getEncoder();
val dec = Base64.getDecoder();

fun main(args: Array<String>) {
    var str = "a".repeat(STR_SIZE)

    var md = MessageDigest.getInstance("MD5")
    var digest = md.digest(str.toByteArray())
    for (byte in digest) print("%02x".format(byte))
    println();

    repeat(TRIES) {
        str = enc.encodeToString(str.toByteArray())
    }
    digest = md.digest(str.toByteArray())
    for (byte in digest) print("%02x".format(byte))
    println();

    repeat(TRIES) {
        val decBytes = dec.decode(str)
        str = String(decBytes)
    }
    digest = md.digest(str.toByteArray())
    for (byte in digest) print("%02x".format(byte))
    println();
}