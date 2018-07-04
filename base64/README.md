# base64 Benchmark

This benchmark (1) constructs a string consisting of 1,000,000 'a' characters, and prints the md5 sum of the string to standard out (STDOUT), (2) repeatedly base64 encodes the string 20 times, re-encoding the previously encoded string each time, and prints the md5 sum of the 20x encoded string string to STDOUT, and then (3) repeatedly base64 decodes the encoded string 20 times, and prints the md5 sum of the decoded string to STDOUT.

### Implementation

An implementation of this benchmark should be defined as in the following pseudocode function definition:

```
function base64_benchmark() {
  str = repeat("a", 1000000)    # assume this produces a string with 1,000,000 'a' characters in it, back to back.
  println(md5(str))

  for i from 1 to 20 {
    str = base64_encode(str)
  }
  println(md5(str))

  for i from 1 to 20 {
    str = base64_decode(str)
  }
  println(md5(str))
}
```

The program should output the following 3 lines of output to standard out (STDOUT):
7707d6ae4e027c70eea2a935c2296f21
82636e8ed2066ac036e6a3aacaf2e94d
7707d6ae4e027c70eea2a935c2296f21

If the program's output doesn't include those 3 lines, then the implementation is deemed incorrect and excluded from the results page. Each line of output should be terminated with a newline.