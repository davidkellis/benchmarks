# Taken from https://github.com/kostya/benchmarks/blob/master/brainfuck2/bf.cr

module Op
  record Inc, val : Int32
  record Move, val : Int32
  record Print
  record Input
  alias T = Inc | Move | Input | Print | Array(Op::T)
end

class Tape
  def initialize
    @tape = [0]
    @pos = 0
  end

  def get
    @tape[@pos]
  end

  def set(x)
    @tape[@pos] = x
  end

  def inc(x)
    @tape[@pos] += x
  end

  def move(x)
    @pos += x
    while @pos >= @tape.size
      @tape << 0
    end
  end
end

class Program
  @ops : Array(Op::T)

  def initialize(code : String)
    @ops = parse(code.each_char)
  end

  def run
    _run @ops, Tape.new
  end

  private def _run(program, tape)
    program.each do |op|
      case op
      when Op::Inc
        tape.inc(op.val)
      when Op::Move
        tape.move(op.val)
      when Array(Op::T)
        while tape.get > 0
          _run(op, tape)
        end
      when Op::Input
        s = STDIN.gets(1) || "a"
        c = s[0]
        tape.set(c.ord)
      when Op::Print
        print(tape.get.chr)
      end
    end
  end

  private def parse(iterator)
    res = [] of Op::T
    iterator.each do |c|
      op = case c
           when '+'; Op::Inc.new(1)
           when '-'; Op::Inc.new(-1)
           when '>'; Op::Move.new(1)
           when '<'; Op::Move.new(-1)
           when 'i'; Op::Input.new
           when 'o'; Op::Print.new
           when '['; parse(iterator)
           when ']'; break
           end
      res << op if op
    end
    res
  end
end

Program.new(File.read(ARGV[0])).run