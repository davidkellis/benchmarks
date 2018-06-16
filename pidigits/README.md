# pidigits Benchmark

This benchmark is part of The Computer Language Benchmarks Game.

The rules, as taken from https://benchmarksgame-team.pages.debian.net/benchmarksgame/description/pidigits.html#pidigits, are:

## Background
MathWorld: [Pi Digits](http://mathworld.wolfram.com/PiDigits.html).

## Variance
Some language implementations have arbitrary precision arithmetic built-in; some provide an arbitrary precision arithmetic library; some use a third-party library ([GMP](http://gmplib.org/)); some provide built-in arbitrary precision arithmetic by wrapping a third-party library.

## The work
The work is to use aribitrary precision arithmetic and the same step-by-step algorithm to generate digits of Pi. Do both extract(3) and extract(4). Don't optimize away the work.

## How to implement
We ask that contributed programs not only give the correct result, but also use the same algorithm to calculate that result.

Each program should:

calculate the first N digits of Pi

print the digits 10-to-a-line, with the running total of digits calculated

diff program output N = 27 with this output:
```
3141592653	:10
5897932384	:20
6264338   	:27
``` 
to check your program output has the correct format, before you contribute your program.

Use a larger command line argument (10000) to check program performance.

Adapt the step-by-step algorithm given on pages 4,6 & 7 of [pdf 156KB] [Unbounded Spigot Algorithms for the Digits of Pi](http://web.comlab.ox.ac.uk/oucl/work/jeremy.gibbons/publications/spigot.pdf). (Not the deliberately obscure version given on page 2. Not the Rabinowitz-Wagon algorithm.)