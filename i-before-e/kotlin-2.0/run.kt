import java.io.File

val pattern = Regex("c?ei")

fun isValid(s: String): Boolean {
    for (match in pattern.findAll(s)) {
        if (!match.value.startsWith("c")) {
            return false
        }
    }
    return true
}

fun main(args: Array<String>) {
    File(args[0]).forEachLine { line ->
        if (!isValid(line)) {
            println(line)
        }
    }
}
