# Taken from https://github.com/kostya/benchmarks/blob/master/base64/test.jl

using Codecs

function main(tries)
  str_size = 10_000_000
  str = repeat("a", str_size)
  str2 = ""

  print("encode: ")
  t = time()
  s = 0
  for i in range(0, tries)
    str2 = String(encode(Base64, str))
    s += length(str2)
  end
  print(s, ", ", time() - t, "\n")

  print("decode: ")
  t = time()
  s = 0
  for i in range(0, tries)
    s += length(String(decode(Base64, str2)))
  end
  print(s, ", ", time() - t, "\n")
end

main(100)
