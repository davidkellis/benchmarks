#!/usr/bin/env ruby

def write_number_file(numbers_path, solution_path)
  numbers = 1_000_000.times.map { rand(1_000_000_000) }
  File.open(numbers_path, 'w') {|f| f.puts(numbers.join(",")) }

  sorted_list = numbers.sort
  solution = (sorted_list.take(10) + sorted_list[-10..-1]).join("\n")
  File.open(solution_path, 'w') {|f| f.puts(solution) }
end

def main
  numbers_path = File.expand_path('./numbers.txt', File.dirname(__FILE__))
  solution_path = File.expand_path('./solution.txt', File.dirname(__FILE__))
  write_number_file(numbers_path, solution_path) unless File.exists?(numbers_path) && File.exists?(solution_path)
end

main if __FILE__ == $0