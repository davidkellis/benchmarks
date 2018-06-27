#!/usr/bin/env ruby

require 'json'

# this method captures the json file generation logic from https://github.com/kostya/benchmarks/blob/master/json/generate_json.rb
def write_json_file(path)
  json = {
    'info' => 'some info',
    'coordinates' => 1_000_000.times.map do
      {
        'x' => rand,
        'y' => rand,
        'z' => rand,
        'name' => ('a'..'z').to_a.shuffle[0..5].join + ' ' + rand(10000).to_s,
        'opts' => {'1' => [1, true]},
      }
    end
  }

  File.open(path, 'w') {|f| JSON.dump(json, f) }
end

def main
  sample_json_path = File.expand_path('./sample.json', File.dirname(__FILE__))
  write_json_file(sample_json_path) unless File.exists?(sample_json_path)
end

main if __FILE__ == $0