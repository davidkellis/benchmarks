import java.math.BigInteger

val ZERO = BigInteger.ZERO
val ONE = BigInteger.ONE
val TWO = BigInteger.valueOf(2)
val THREE = BigInteger.valueOf(3)
val FOUR = BigInteger.valueOf(4)
val SEVEN = BigInteger.valueOf(7)
val TEN = BigInteger.TEN

fun main(args: Array<String>) {
    val n = if (args.isNotEmpty()) args[0].toInt() else 10000
    var q = ONE; var r = ZERO; var t = ONE
    var k = ONE; var nd = THREE; var l = THREE
    var count = 0
    val sb = StringBuilder()

    while (count < n) {
        if (FOUR * q + r - t < nd * t) {
            sb.append(nd)
            count++
            if (count % 10 == 0) sb.append("\t:$count\n")
            val nr = TEN * (r - nd * t)
            nd = TEN * (THREE * q + r) / t - TEN * nd
            q *= TEN
            r = nr
        } else {
            val nr = (TWO * q + r) * l
            val nn = (q * (SEVEN * k + TWO) + r * l) / (t * l)
            q *= k
            t *= l
            l += TWO
            k += ONE
            nd = nn
            r = nr
        }
    }
    if (count % 10 != 0) {
        sb.append(" ".repeat(10 - count % 10) + "\t:$count\n")
    }
    print(sb)
}
