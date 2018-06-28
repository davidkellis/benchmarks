// Taken from https://github.com/kostya/benchmarks/blob/master/brainfuck2/bf.js

var inputQueue = "";

const readline = require('readline');
const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

rl.on('line', (line) => {
  inputQueue = inputQueue + line;
  // console.log(`Received: ${line}`);
});

function getc() {
  
}

function StringIterator(str){
  this.str = str;
  this.current = 0;
  this.last = str.length - 1;

  this.done = function(){
    if (this.current > this.last)
      return true;
    else
      return false;
  };

  this.next = function(){
    if (this.current > this.last)
      throw StopIteration;
    else
      return this.str[this.current++];
  };
}

var Tape = function() {
  var pos = 0, tape = [0];
  this.inc = function(x) { tape[pos] += x; }
  this.move = function(x) { pos += x; while (pos >= tape.length) tape.push(0); }
  this.get = function() { return tape[pos]; }
  this.set = function(x) { tape[pos] = x; }
}

const INC = 1;
const MOVE = 2;
const LOOP = 3;
const PRINT = 4;
const INPUT = 4;

function Op(op, v) {
  this.op = op;
  this.v = v;
}

var Brainfuck = function(text) {
  var me = this;

  var parse = function(iterator) {
    var res = [];
    while (!iterator.done()) {
      switch(iterator.next()) {
        case '+': res.push(new Op(INC, 1)); break;
        case '-': res.push(new Op(INC, -1)); break;
        case '>': res.push(new Op(MOVE, 1)); break;
        case '<': res.push(new Op(MOVE, -1)); break;
        case 'i': res.push(new Op(INPUT, 0)); break;
        case 'o': res.push(new Op(PRINT, 0)); break;
        case '[': res.push(new Op(LOOP, parse(iterator))); break;
        case ']': return res;
      }
    }
    return res;
  }

  me.ops = parse(new StringIterator(text));

  var _run = function(ops, tape) {
    for (var i = 0; i < ops.length; i++) {
      var op = ops[i];
      switch(op.op) {
        case INC: tape.inc(op.v); break;
        case MOVE: tape.move(op.v); break;
        case LOOP: while (tape.get() > 0) _run(op.v, tape); break;
        case INPUT: tape.set(); break;
        case PRINT: process.stdout.write(String.fromCharCode(tape.get())); break;
      }
    }
  };

  me.run = function() {
    _run(me.ops, new Tape());
  };
}

var text = require('fs').readFileSync(process.argv[2].toString()).toString(); 
var brainfuck = new Brainfuck(text);
brainfuck.run();