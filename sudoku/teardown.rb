#!/usr/bin/env ruby

def main
  puzzles_path = File.expand_path('./puzzles.txt', File.dirname(__FILE__))
  solution_path = File.expand_path('./solution.txt', File.dirname(__FILE__))
  File.delete(puzzles_path) if File.exists?(puzzles_path)
  File.delete(solution_path) if File.exists?(solution_path)
end

main if __FILE__ == $0