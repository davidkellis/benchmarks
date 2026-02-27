require "base64"
require "digest"

STR_SIZE = 1_000_000
TRIES    =        20

str = "a" * STR_SIZE
str2 = ""
puts Digest::MD5.hexdigest(str)

TRIES.times do |i|
  str = Base64.strict_encode(str)
end
puts Digest::MD5.hexdigest(str)

TRIES.times do |i|
  str = Base64.decode(str)
end
puts Digest::MD5.hexdigest(str)