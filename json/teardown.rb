#!/usr/bin/env ruby

def main
  sample_json_path = File.expand_path('./sample.json', File.dirname(__FILE__))
  File.delete(sample_json_path) if File.exist?(sample_json_path)
end

main if __FILE__ == $0
