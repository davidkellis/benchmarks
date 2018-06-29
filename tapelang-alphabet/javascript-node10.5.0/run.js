// Taken from https://github.com/kostya/benchmarks/blob/master/brainfuck2/bf.js

var readlineSync = require('readline-sync');

function getc() {
  return readlineSync.keyIn();
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
        case INPUT:
          //tape.set(getc());
          /*
          TODO: fix the line above ^^^, as it currently blows up with this:
          Successfully tagged docker_tapelang-alphabet_javascript-node10.5.0:latest
              docker run --rm docker_tapelang-alphabet_javascript-node10.5.0
              stty: when specifying an output style, modes may not be set
          stty: standard input: Inappropriate ioctl for device
          /app/node_modules/readline-sync/lib/readline-sync.js:250
              if (res.error) { throw res.error; }
                              ^

          Error: The current environment doesn't support interactive reading from TTY.
          stty: when specifying an output style, modes may not be set
          stty: standard input: Inappropriate ioctl for device
              at readlineExt (/app/node_modules/readline-sync/lib/readline-sync.js:212:19)
              at tryExt (/app/node_modules/readline-sync/lib/readline-sync.js:249:15)
              at /app/node_modules/readline-sync/lib/readline-sync.js:352:15
              at _readlineSync (/app/node_modules/readline-sync/lib/readline-sync.js:422:5)
              at Object.exports.keyIn (/app/node_modules/readline-sync/lib/readline-sync.js:877:17)
              at getc (/app/run.js:6:23)
              at _run (/app/run.js:77:30)
              at _run (/app/run.js:76:43)
              at Brainfuck.me.run (/app/run.js:84:5)
              at Object.<anonymous> (/app/run.js:90:11)
          Command exited with non-zero status 1
          */

          break;
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