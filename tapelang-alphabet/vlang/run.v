import os

enum OpType {
	inc
	mov
	prn
	loop
}

struct Op {
	op_type OpType
	val     int
	loop    []Op
}

struct Tape {
mut:
	cells []int = [0]
	pos   int
}

fn (t Tape) get() int {
	return t.cells[t.pos]
}

fn (mut t Tape) inc(v int) {
	t.cells[t.pos] += v
}

fn (mut t Tape) mov(v int) {
	t.pos += v
	for t.pos >= t.cells.len {
		t.cells << 0
	}
	for t.pos < 0 {
		old := t.cells.len
		mut nc := []int{len: old}
		nc << t.cells
		t.cells = nc
		t.pos += old
	}
}

fn parse(src string, mut pos &int) []Op {
	mut ops := []Op{}
	for *pos < src.len {
		c := src[*pos]
		if c == `+` || c == `-` {
			mut v := if c == `+` { 1 } else { -1 }
			(*pos)++
			for *pos < src.len && src[*pos] == c {
				v += if c == `+` { 1 } else { -1 }
				(*pos)++
			}
			ops << Op{
				op_type: .inc
				val: v
			}
		} else if c == `>` || c == `<` {
			mut v := if c == `>` { 1 } else { -1 }
			(*pos)++
			for *pos < src.len && src[*pos] == c {
				v += if c == `>` { 1 } else { -1 }
				(*pos)++
			}
			ops << Op{
				op_type: .mov
				val: v
			}
		} else if c == `.` {
			ops << Op{
				op_type: .prn
			}
			(*pos)++
		} else if c == `[` {
			(*pos)++
			loop_ops := parse(src, mut pos)
			ops << Op{
				op_type: .loop
				loop: loop_ops
			}
		} else if c == `]` {
			(*pos)++
			break
		} else {
			(*pos)++
		}
	}
	return ops
}

fn run_ops(ops []Op, mut tape Tape) {
	for op in ops {
		match op.op_type {
			.inc { tape.inc(op.val) }
			.mov { tape.mov(op.val) }
			.prn { print(rune(tape.get()).str()) }
			.loop {
				for tape.get() != 0 {
					run_ops(op.loop, mut tape)
				}
			}
		}
	}
}

fn main() {
	path := os.args[1]
	src := os.read_file(path) or { panic(err) }
	mut pos := 0
	ops := parse(src, mut &pos)
	mut tape := Tape{}
	run_ops(ops, mut tape)
}
