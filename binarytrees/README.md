# binary-trees Benchmark

This benchmark is part of [The Computer Language Benchmarks Game](https://benchmarksgame-team.pages.debian.net/benchmarksgame/).

The rules, as taken from https://benchmarksgame-team.pages.debian.net/benchmarksgame/description/binarytrees.html#binarytrees, are:

## Background
A simplistic adaptation of [Hans Boehm's GCBench](http://hboehm.info/gc/gc_bench/), which in turn was adapted from a benchmark by John Ellis and Pete Kovac.

Thanks to Christophe Troestler and Einar Karttunen for help with this benchmark.

## Variance
Use default GC, use per node allocation or use a library memory pool.

As a practical matter, the myriad ways to tune GC will not be accepted.

As a practical matter, the myriad ways to custom allocate memory will not be accepted.

Please don't implement your own custom ["arena"](http://www.stroustrup.com/bs_faq2.html#placement-delete) or "memory pool" or "free list" - they will not be accepted.

## The work
The work is to fully create perfect binary trees - before any tree nodes are GC'd - using at-minimum the number of allocations of [Jeremy Zerfas's C program](https://benchmarksgame-team.pages.debian.net/benchmarksgame/program/binarytrees-gcc-3.html). Don't optimize away the work.

How to implement
We ask that contributed programs not only give the correct result, but also use the same algorithm to calculate that result.

Each program should:

define a tree node class and methods, or a tree node record and procedures, or an algebraic data type and functions, or…

allocate a binary tree to 'stretch' memory, check it exists, and deallocate it

allocate a long-lived binary tree which will live-on while other trees are allocated and deallocated

allocate, walk, and deallocate many bottom-up binary trees

allocate a tree

walk the tree, counting the nodes (and maybe deallocate the nodes)

deallocate the tree

check that the long-lived binary tree still exists

diff program output N = 10 with this 1KB output file:
```
stretch tree of depth 11	 check: 4095
1024	 trees of depth 4	 check: 31744
256	 trees of depth 6	 check: 32512
64	 trees of depth 8	 check: 32704
16	 trees of depth 10	 check: 32752
long lived tree of depth 10	 check: 2047
```
to check your program output has the correct format, before you contribute your program.

Use a larger command line argument (21) to check program performance.

Thanks to Eamon Nerbonne for repeatedly showing what was wrong with the old way of checking these programs, and to Brad Chamberlain for suggesting that a simple check should work.