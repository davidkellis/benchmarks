# fib Benchmark

This benchmark calculates the 45th Fibonacci number: `fib(45) = 1,134,903,170`.

The nth Fibonacci number is defined by the following equation:
`fib(n) = fib(n - 1) + fib(n - 2)`
such that `n >= 1`, and `fib(1)` and `fib(2)` are defined to be 1.

The Fibonacci sequence starts out as:

    1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, ...

because

    F(1) = 1
    F(2) = 1
    F(3) = 2
    F(4) = 3
    F(5) = 5
    ...

### Implementation

An implementation of this benchmark should be defined as in the following pseudocode function definition:

```
function fib(n) {
  if n <= 2
    return 1
  else
    return fib(n - 1) + fib(n - 2)
}
```

The parameter `n` should be typed as a 32-bit integer. The `fib` function should return a 32-bit integer.

The program should print a single line of output to standard out (STDOUT), consisting of the 45th Fibonacci number. The line should be terminated with a newline.