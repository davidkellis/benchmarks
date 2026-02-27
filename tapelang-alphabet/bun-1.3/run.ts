enum OpType { Inc, Move, Print, Loop }

interface Op {
  type: OpType;
  val: number;
  loop?: Op[];
}

class Tape {
  cells: number[] = [0];
  pos = 0;
  get(): number { return this.cells[this.pos]; }
  inc(v: number) { this.cells[this.pos] += v; }
  move(v: number) {
    this.pos += v;
    while (this.pos >= this.cells.length) this.cells.push(0);
    while (this.pos < 0) {
      const old = this.cells.length;
      this.cells = new Array(old).fill(0).concat(this.cells);
      this.pos += old;
    }
  }
}

function parse(src: string, pos: { v: number }): Op[] {
  const ops: Op[] = [];
  while (pos.v < src.length) {
    const c = src[pos.v];
    if (c === '+' || c === '-') {
      let v = c === '+' ? 1 : -1;
      pos.v++;
      while (pos.v < src.length && src[pos.v] === c) { v += c === '+' ? 1 : -1; pos.v++; }
      ops.push({ type: OpType.Inc, val: v });
    } else if (c === '>' || c === '<') {
      let v = c === '>' ? 1 : -1;
      pos.v++;
      while (pos.v < src.length && src[pos.v] === c) { v += c === '>' ? 1 : -1; pos.v++; }
      ops.push({ type: OpType.Move, val: v });
    } else if (c === '.') {
      ops.push({ type: OpType.Print, val: 0 });
      pos.v++;
    } else if (c === '[') {
      pos.v++;
      ops.push({ type: OpType.Loop, val: 0, loop: parse(src, pos) });
    } else if (c === ']') {
      pos.v++;
      break;
    } else {
      pos.v++;
    }
  }
  return ops;
}

function run(ops: Op[], tape: Tape) {
  for (const op of ops) {
    switch (op.type) {
      case OpType.Inc: tape.inc(op.val); break;
      case OpType.Move: tape.move(op.val); break;
      case OpType.Print: process.stdout.write(String.fromCharCode(tape.get())); break;
      case OpType.Loop: while (tape.get() !== 0) run(op.loop!, tape); break;
    }
  }
}

const path = process.argv[2] || Bun.argv[2];
const src = await Bun.file(path).text();
const pos = { v: 0 };
const ops = parse(src, pos);
const tape = new Tape();
run(ops, tape);
