import java.io.File

fun main() {
    val text = File("sample.json").readText()

    // Simple manual JSON parsing for performance
    var x = 0.0
    var y = 0.0
    var z = 0.0
    var count = 0
    var idx = 0

    while (true) {
        idx = text.indexOf("\"x\"", idx)
        if (idx == -1) break
        idx = text.indexOf(':', idx) + 1
        val xEnd = findNumberEnd(text, idx)
        val xv = text.substring(idx, xEnd).trim().toDouble()
        idx = xEnd

        idx = text.indexOf("\"y\"", idx)
        if (idx == -1) break
        idx = text.indexOf(':', idx) + 1
        val yEnd = findNumberEnd(text, idx)
        val yv = text.substring(idx, yEnd).trim().toDouble()
        idx = yEnd

        idx = text.indexOf("\"z\"", idx)
        if (idx == -1) break
        idx = text.indexOf(':', idx) + 1
        val zEnd = findNumberEnd(text, idx)
        val zv = text.substring(idx, zEnd).trim().toDouble()
        idx = zEnd

        x += xv
        y += yv
        z += zv
        count++
    }

    println("%.8f".format(x / count))
    println("%.8f".format(y / count))
    println("%.8f".format(z / count))
}

fun findNumberEnd(text: String, start: Int): Int {
    var i = start
    while (i < text.length && (text[i] == ' ' || text[i] == '\t' || text[i] == '\n' || text[i] == '\r')) i++
    if (i < text.length && text[i] == '-') i++
    while (i < text.length && (text[i] in '0'..'9' || text[i] == '.' || text[i] == 'e' || text[i] == 'E' || text[i] == '+' || text[i] == '-')) {
        if (text[i] == '-' && i > start && text[i-1] != 'e' && text[i-1] != 'E') break
        i++
    }
    return i
}
