#!/usr/bin/env ruby

def write_number_file(path)
  numbers = 1_000_000.times.map { rand(1_000_000_000) }

  File.open(path, 'w') {|f| f.puts(numbers.join(",")) }
end

def main
  path = File.expand_path('./numbers.txt', File.dirname(__FILE__))
  write_number_file(path) unless File.exists?(path)
end

main if __FILE__ == $0