# Taken from https://github.com/kostya/benchmarks/blob/master/base64/test.rb

require 'base64'
require 'digest'

t1 = Time.now

STR_SIZE = 1_000_000
REPETITIONS = 20

str = "a" * STR_SIZE
puts Digest::MD5.hexdigest(str)

REPETITIONS.times do |i|
  str = Base64.strict_encode64(str)
end
puts Digest::MD5.hexdigest(str)

REPETITIONS.times do |i|
  str = Base64.strict_decode64(str)
end
puts Digest::MD5.hexdigest(str)

t2 = Time.now
puts "base64:ruby2.5.1:time=#{t2 - t1}s"