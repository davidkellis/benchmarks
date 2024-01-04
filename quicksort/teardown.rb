#!/usr/bin/env ruby

def main
  numbers_path = File.expand_path('./numbers.txt', File.dirname(__FILE__))
  solution_path = File.expand_path('./solution.txt', File.dirname(__FILE__))
  File.delete(numbers_path) if File.exist?(numbers_path)
  File.delete(solution_path) if File.exist?(solution_path)
end

main if __FILE__ == $0
