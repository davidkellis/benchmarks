use std::fs;
use std::env;

enum Op {
    Inc(i32),
    Move(i32),
    Print,
    Loop(Vec<Op>),
}

struct Tape {
    cells: Vec<i32>,
    pos: i32,
}

impl Tape {
    fn new() -> Self { Tape { cells: vec![0], pos: 0 } }
    fn get(&self) -> i32 { self.cells[self.pos as usize] }
    fn inc(&mut self, v: i32) { self.cells[self.pos as usize] += v; }
    fn mv(&mut self, v: i32) {
        self.pos += v;
        while self.pos as usize >= self.cells.len() { self.cells.push(0); }
        while self.pos < 0 {
            let old_len = self.cells.len();
            let mut new_cells = vec![0i32; old_len];
            new_cells.extend_from_slice(&self.cells);
            self.cells = new_cells;
            self.pos += old_len as i32;
        }
    }
}

fn parse(chars: &[u8], pos: &mut usize) -> Vec<Op> {
    let mut ops = Vec::new();
    while *pos < chars.len() {
        match chars[*pos] {
            b'+' | b'-' => {
                let c = chars[*pos];
                let mut v: i32 = if c == b'+' { 1 } else { -1 };
                *pos += 1;
                while *pos < chars.len() && chars[*pos] == c { v += if c == b'+' { 1 } else { -1 }; *pos += 1; }
                ops.push(Op::Inc(v));
            }
            b'>' | b'<' => {
                let c = chars[*pos];
                let mut v: i32 = if c == b'>' { 1 } else { -1 };
                *pos += 1;
                while *pos < chars.len() && chars[*pos] == c { v += if c == b'>' { 1 } else { -1 }; *pos += 1; }
                ops.push(Op::Move(v));
            }
            b'.' => { ops.push(Op::Print); *pos += 1; }
            b'[' => { *pos += 1; ops.push(Op::Loop(parse(chars, pos))); }
            b']' => { *pos += 1; break; }
            _ => { *pos += 1; }
        }
    }
    ops
}

fn run(ops: &[Op], tape: &mut Tape) {
    for op in ops {
        match op {
            Op::Inc(v) => tape.inc(*v),
            Op::Move(v) => tape.mv(*v),
            Op::Print => print!("{}", tape.get() as u8 as char),
            Op::Loop(body) => { while tape.get() != 0 { run(body, tape); } }
        }
    }
}

fn main() {
    let args: Vec<String> = env::args().collect();
    let src = fs::read_to_string(&args[1]).unwrap();
    let bytes = src.as_bytes();
    let mut pos = 0;
    let ops = parse(bytes, &mut pos);
    let mut tape = Tape::new();
    run(&ops, &mut tape);
}
