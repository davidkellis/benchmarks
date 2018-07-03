# base64 Benchmark

This benchmark (1) constructs a string consisting of 10,000,000 'a' characters, (2) base64 encodes the string 100 times, (3) base64 decodes the encoded string 100 times, and then (4) compares the unencoded string generated in step (1) with the decoded string in step (3) and prints whether they match or not.

### Implementation

An implementation of this benchmark should be defined as in the following pseudocode function definition:

```
SIZE = 10000000
function base64_benchmark() {
  raw_string = repeat("a", SIZE)    # assume this produces a string with 10,000,000 'a' characters in it, back to back.
  encoded_string = ""
  decoded_string = ""

  for i from 1 to 100 {
    encoded_string = base64_encode(raw_string)
  }

  for i from 1 to 100 {
    decoded_string = base64_decode(encoded_string)
  }

  if raw_string == decoded_string
    puts "match"
  else
    puts "no match"
  end
}
```

The program should print a single line of output to standard out (STDOUT), consisting of either the string "match" or "no match". If the program prints "no match", then the implementation is deemed incorrect and should be corrected. The line of output should be terminated with a newline.