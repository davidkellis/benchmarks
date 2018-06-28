# Taken from https://github.com/davidkellis/tapelang/blob/master/tapelang.rb

module Translate
  class << self
    def translate_brainfuck(brainfuck_source_code)
      brainfuck_source_code.
        # gsub(/([^+\-<>,.\[\]\n]+)/, "#\\0\n").    # this attempts to comment out anything in a brainfuck program that is outside the valid command character set; however, it seems to be unnecessary, per https://esolangs.org/wiki/Brainfuck_algorithms#Header_comment
        tr(",.", "io")
    end

    def run
      print(translate_brainfuck(ARGF.read))
    end
  end
end

Op = Struct.new(:op, :val)

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
  def initialize(source_code)
    # @console = IO.console
    @ops = parse(source_code.each_char)
  end

  def run
    evaluate(@ops, Tape.new)
  end

private

  def evaluate(program, tape)
    program.each do |op|
      case op.op
      when :inc; tape.inc(op.val)
      when :move; tape.move(op.val)
      when :loop; evaluate(op.val, tape) while tape.get > 0
      # when :input; tape.set(STDIN.getch.ord)
      # when :input; tape.set(@console.getch.ord)
      when :input; tape.set(STDIN.getc.ord)
      when :output; STDOUT.print(tape.get.chr)
      end
    end
  end

  def parse(char_iterator)
    skip_until_eol = false
    res = []
    while c = char_iterator.next rescue nil
      skip_until_eol = skip_until_eol && c != "\n"
      # print("##{c}") if skip_until_eol      # print out the commented-out commands
      next if skip_until_eol

      op = case c
      when '#'; skip_until_eol = true ; nil
      when '+'; Op.new(:inc, 1)
      when '-'; Op.new(:inc, -1)
      when '>'; Op.new(:move, 1)
      when '<'; Op.new(:move, -1)
      when 'o'; Op.new(:output, 0)
      when 'i'; Op.new(:input, 0)
      when '['; Op.new(:loop, parse(char_iterator))
      when ']'; break
      else; nil
      end

      res << op if op
    end
    res
  end
end

def main
  program_source = if ARGV.empty?
    ARGF.read
  else
    filename = ARGV[0]
    ARGV.clear
    if File.exists?(filename)
      case
      when filename.end_with?(".tape")
        File.read(filename)
      when filename.end_with?(".b") || filename.end_with?(".bf")
        Translate.translate_brainfuck(File.read(filename))
      else
        STDERR.puts("Unknown file type. Unable to intepret file #{filename}.")
        exit(1)
      end
    else
      STDERR.puts("File #{filename} does not exist.")
      exit(1)
    end
  end

  Program.new(program_source).run
end

main if __FILE__ == $0