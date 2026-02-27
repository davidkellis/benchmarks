import java.io.File

sealed class Op {
    data class Inc(val v: Int) : Op()
    data class Move(val v: Int) : Op()
    object Print : Op()
    data class Loop(val ops: List<Op>) : Op()
}

class Tape {
    private var cells = IntArray(1)
    var pos = 0
    fun get(): Int = cells[pos]
    fun inc(v: Int) { cells[pos] += v }
    fun move(v: Int) {
        pos += v
        while (pos >= cells.size) { val old = cells; cells = IntArray(old.size * 2); old.copyInto(cells) }
        while (pos < 0) { val old = cells; cells = IntArray(old.size * 2); old.copyInto(cells, old.size); pos += old.size }
    }
}

class Parser(val src: String, var pos: Int = 0) {
    fun parse(): List<Op> {
        val ops = mutableListOf<Op>()
        while (pos < src.length) {
            when (val c = src[pos++]) {
                '+', '-' -> { var v = if (c == '+') 1 else -1; while (pos < src.length && src[pos] == c) { v += if (c == '+') 1 else -1; pos++ }; ops.add(Op.Inc(v)) }
                '>', '<' -> { var v = if (c == '>') 1 else -1; while (pos < src.length && src[pos] == c) { v += if (c == '>') 1 else -1; pos++ }; ops.add(Op.Move(v)) }
                '.' -> ops.add(Op.Print)
                '[' -> ops.add(Op.Loop(parse()))
                ']' -> break
            }
        }
        return ops
    }
}

fun run(ops: List<Op>, tape: Tape) {
    for (op in ops) {
        when (op) {
            is Op.Inc -> tape.inc(op.v)
            is Op.Move -> tape.move(op.v)
            is Op.Print -> print(tape.get().toChar())
            is Op.Loop -> { while (tape.get() != 0) run(op.ops, tape) }
        }
    }
}

fun main(args: Array<String>) {
    val src = File(args[0]).readText()
    val ops = Parser(src).parse()
    val tape = Tape()
    run(ops, tape)
}
