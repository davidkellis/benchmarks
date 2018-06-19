#!/usr/bin/env ruby

def main
  path = File.expand_path('./numbers.txt', File.dirname(__FILE__))
  File.delete(path) if File.exists?(path)
end

main if __FILE__ == $0