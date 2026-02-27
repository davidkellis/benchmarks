# Copied with little modifications from: http://benchmarksgame.alioth.debian.org/u64q/benchmark.php?test=binarytrees&lang=yarv&id=1&data=u64q

# The Computer Language Benchmarks Game
# https://salsa.debian.org/benchmarksgame-team/benchmarksgame/
#
# contributed by Jesse Millikan
# Modified by Wesley Moxam
# *reset*

class Node
  def initialize(@a : Node?, @b : Node?)
  end

  property :a
  property :b
end

def item_check(left, right)
  return 1 if left.nil? || right.nil?
  1 + item_check(left.a, left.b) + item_check(right.a, right.b)
end

def bottom_up_tree(depth)
  return Node.new(nil, nil) unless depth > 0
  depth -= 1
  Node.new(bottom_up_tree(depth), bottom_up_tree(depth))
end

max_depth = ARGV[0].to_i
min_depth = 4

max_depth = min_depth + 2 if max_depth < min_depth + 2

stretch_depth = max_depth + 1
stretch_tree = bottom_up_tree(stretch_depth)

puts "stretch tree of depth #{stretch_depth}\t check: #{item_check(stretch_tree.a, stretch_tree.b)}"
stretch_tree = nil

long_lived_tree = bottom_up_tree(max_depth)

min_depth.step(to: max_depth, by: 2) do |depth|
  iterations = 2**(max_depth - depth + min_depth)

  check = 0

  (1..iterations).each do |i|
    temp_tree = bottom_up_tree(depth)
    check += item_check(temp_tree.a, temp_tree.b)
  end

  puts "#{iterations}\t trees of depth #{depth}\t check: #{check}"
end

puts "long lived tree of depth #{max_depth}\t check: #{item_check(long_lived_tree.a, long_lived_tree.b)}"