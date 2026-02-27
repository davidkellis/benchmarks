import java.io.File

class SudokuSolver {
    val R = Array(729) { IntArray(4) }
    val C = Array(324) { IntArray(9) }
    val sc = IntArray(324)

    fun init() {
        val nr = IntArray(324)
        for (i in 0 until 729) {
            val r2 = i / 9; val c2 = i % 9
            val row = r2 / 9; val col = r2 % 9; val box = row / 3 * 3 + col / 3
            val cc = intArrayOf(9 * row + c2, 81 + 9 * col + c2, 162 + 9 * box + c2, 243 + r2)
            for (j in 0 until 4) { R[i][j] = cc[j]; C[cc[j]][nr[cc[j]]++] = i }
        }
        for (i in 0 until 324) sc[i] = 9
    }

    fun update(sr: IntArray, r: Int, v: Int): Int {
        var min = 10; var minC = -1
        for (j in 0 until 4) sc[R[r][j]] += if (v < 0) -10 else 10
        for (j in 0 until 4) {
            val c = R[r][j]
            if (v > 0) {
                for (k in 0 until 9) { val rr = C[c][k]; if (sr[rr]++ != 0) continue
                    for (l in 0 until 4) { if (--sc[R[rr][l]] < min) { min = sc[R[rr][l]]; minC = R[rr][l] } } }
            } else {
                for (k in 0 until 9) { val rr = C[c][k]; if (--sr[rr] != 0) continue
                    for (l in 0 until 4) ++sc[R[rr][l]] }
            }
        }
        return minC
    }

    fun solve(sr: IntArray, sol: IntArray, depth: Int): Int {
        var min = 10; var bestC = -1
        for (i in 0 until 324) if (sc[i] < min) { min = sc[i]; bestC = i }
        if (min == 0 || min == 10) return if (min == 10) 1 else 0
        for (k in 0 until 9) {
            val r = C[bestC][k]; if (sr[r] != 0) continue
            sol[depth] = r; update(sr, r, 1)
            if (solve(sr, sol, depth + 1) > 0) return 1
            update(sr, r, -1)
        }
        return 0
    }

    fun solvePuzzle(puzzle: String): String {
        init()
        val sr = IntArray(729); val sol = IntArray(81)
        val result = puzzle.toCharArray()
        for (i in 0 until 81) {
            if (puzzle[i] in '1'..'9') update(sr, i * 9 + (puzzle[i] - '1'), 1)
        }
        if (solve(sr, sol, 0) > 0) {
            for (j in 0 until 81) { if (sol[j] > 0 || (j == 0 && sol[0] > 0)) {
                val s = sol[j]; val cell = s / 9; val digit = s % 9 + 1
                if (result[cell] == '0') result[cell] = ('0' + digit)
            }}
        }
        return String(result)
    }
}

fun main() {
    val solver = SudokuSolver()
    val lines = File("sudoku.txt").readLines()
    repeat(10) {
        for (line in lines) {
            val trimmed = line.trim()
            if (trimmed.length >= 81) println(solver.solvePuzzle(trimmed))
        }
    }
}
