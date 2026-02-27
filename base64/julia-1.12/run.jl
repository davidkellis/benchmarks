# Taken from https://github.com/kostya/benchmarks/blob/master/base64/test.jl

using Codecs
using MD5

function main(tries)
  str_size = 1_000_000
  str = repeat("a", str_size)
  println(bytes2hex(md5(str)))

  for i in range(0, tries)
    str = String(encode(Base64, str))
  end
  println(bytes2hex(md5(str)))

  for i in range(0, tries)
    str = String(decode(Base64, str))
  end
  println(bytes2hex(md5(str)))
end

main(20)
