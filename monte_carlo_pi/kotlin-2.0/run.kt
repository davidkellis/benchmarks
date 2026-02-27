import kotlin.math.hypot
import kotlin.random.Random

fun approxPi(throws: Int): Double {
    var inside = 0
    for (i in 0 until throws) {
        val x = Random.nextDouble()
        val y = Random.nextDouble()
        if (hypot(x, y) <= 1.0) {
            inside++
        }
    }
    return 4.0 * inside / throws
}

fun main() {
    for (n in listOf(1000, 10000, 100000, 1000000, 10000000)) {
        println("%8d samples: PI = %s".format(n, approxPi(n)))
    }
}
