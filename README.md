# benchmarks

This project aims to replicate a variety of benchmarks taken from various sources.

A sample benchmark report run on a MacBook Pro (Retina, 13-inch, Early 2015, 2.7 GHz Intel Core i5, 16 GB 1867 MHz DDR3) can be seen at https://davidkellis.github.io/benchmarks/.

Every benchmark implementation runs in a self-contained Docker container. Necessary build and runtime artifacts are copied into the container.


## How to run all benchmarks

1. Install Docker Community Edition (see https://store.docker.com/search?type=edition&offering=community)
2. Install Ruby 2.0+
3. `git clone git@github.com:davidkellis/benchmarks.git`
4. `cd benchmarks`
5. `./run.rb`
6. Open `./index.html` in a web browser to view the results.


## Benchmark Suite

Many benchmark ideas and implementations are taken from:
- https://benchmarksgame-team.pages.debian.net/benchmarksgame/
- https://github.com/kostya/benchmarks
- https://github.com/kostya/crystal-benchmarks-game
- https://github.com/attractivechaos/plb
- https://github.com/drujensen/fib
- https://github.com/trizen/language-benchmarks
- https://github.com/JuliaLang/Microbenchmarks
- https://github.com/archer884/i-before-e

Attribution is captured in each benchmark program implementation.


### [base64](base64/README.md)

The base64 benchmark (1) constructs a string consisting of 10,000,000 'a' characters, (2) base64 encodes the string 100 times, (3) base64 decodes the encoded string 100 times, and then (4) compares the unencoded string generated in step (1) with the decoded string in step (3) and prints whether they match or not.

### [binarytrees](binarytrees/README.md)

The binarytrees benchmark constructs [perfect binary trees](https://en.wikipedia.org/wiki/Binary_tree#Types_of_binary_trees) of various heights in an attempt to exercise memory allocation and deallocation performance.

### [fib](fib/README.md)

The fib benchmark calculates and prints the 45th Fibonacci number, 1,134,903,170.

### i-before-e
The i-before-e benchmark, taken from https://github.com/archer884/i-before-e, implements a variation of the r/dailyprogrammer challenge for 2018-06-11 (see https://www.reddit.com/r/dailyprogrammer/comments/8q96da/20180611_challenge_363_easy_i_before_e_except/).

Specifically, this benchmark lists the words from the enable1 word list that are exceptions to the rule "i before e except after c".

### [json](json/README.md)

The json benchmark reads a json document from disk, parses the json document, extracts 3-dimensional coordinates from the in-memory json document, calculates the arithmetic average of the coordinates, and then prints the averages to STDOUT.

### [matrixmultiply](matrixmultiply/README.md)

The matrixmultiply benchmark calculates the product of two 1000x1000 element matrices using the standard iterative matrix multiplication algorithm described at https://en.wikipedia.org/wiki/Matrix_multiplication_algorithm#Iterative_algorithm.

### matrixmultiply-fast

The matrixmultiply-fast benchmark is identical to the matrixmultiply benchmark, with the exception that optimized matrix multiplication libraries and optimized matrix multiplication algorithms may be used in place of the naively implemented standard iterative algorithm that is mandated in the matrixmultiply benchmark.

### [pidigits](pidigits/README.md)

The pidigits benchmark uses aribitrary precision arithmetic to implement the step-by-step "spigot" algorithm described in http://web.comlab.ox.ac.uk/oucl/work/jeremy.gibbons/publications/spigot.pdf to generate the first 10,000 digits of Pi.

### quicksort

The quicksort benchmark reads a comma-delimited list of double precision floating point values from a text file on disk into memory, and then sorts the list of floating point values in ascending order using the [Quicksort](https://en.wikipedia.org/wiki/Quicksort) sorting algorithm.

### sudoku

The sudoku benchmark reads a puzzle file consisting of 20 sudoku puzzles from disk, solves them sequentially, and then prints out the solved puzzles.

### tapelang-alphabet

The tapelang-alphabet benchmark tests how quickly a [Tapelang](https://github.com/davidkellis/tapelang) interpreter can execute a Tapelang program that prints the alphabet in reverse order, from Z to A.


## How to add benchmarks

Every directory in the top level project directory corresponds to a benchmark suite. For example:
```
benchmarks
- base64
- json
- pidigits
- ...
```

Within the directory for a given benchmark suite, there are five things: (1) benchmark implementation directories, (2) a README.md that defines the benchmark specification, including any relevant rules/guidelines for implementing the benchmark, (3) an optional setup.rb script, (4) an optional teardown.rb script, and (5) any extra artifacts that are necessary for the benchmark suite to be executed.

Each benchmark implementation is a directory with a `Dockerfile` that defines how to build and run the benchmark implementation.

### To add a new benchmark suite

If we're going to add a new benchmark, count_to_a_million, then we do the following:

1. Add a top-level directory in the project's root directory. For example, `mkdir count_to_a_million`.
2. If there needs to be any prep work done prior to the execution of the benchmark implementations, then create a script called `setup.rb` in the `count_to_a_million` directory, and add whatever setup logic needs to be evaluated prior to the execution of the implementations for that benchmark suite to the `setup.rb` script.
3. If there needs to be any teardown work performed after all the benchmark implementations for the benchmark suite are run, then create a script called `teardown.rb` in the `count_to_a_million` directory.
4. Add benchmark implementations.

### To add a new benchmark implementation

If we're going to add a new ruby 2.5.0 implementation of the count_to_a_million benchmark, then we would create a new subdirectory within the `count_to_a_million` benchmark suite directory (i.e. `<project root>/count_to_a_million/ruby2.5.0`), and then add the souce code that implements the benchmark, as well as the Dockerfile for that implementation.

The `Dockerfile` for every benchmark implementation must copy the `time.sh` script into the container, and execute the benchmark via the `time.sh` script. For example:
```
FROM ruby:2.5.0

RUN apt-get update && apt-get install time

WORKDIR /app

# keep in mind that the docker build command is being run from the benchmarks/ project's root directory
# and the context directory is being specified as the benchmarks/ root directory
COPY time.sh .      # copy the time.sh script into the container's working directory (i.e. /app)
COPY count_to_a_million/ruby2.5.0/run.rb .      # copy the implementation of the benchmark into the container's working directory (i.e. /app)

CMD ["./time.sh", "ruby", "run.rb"]     # run the benchmark implementation via the time.sh script
```

## Sample Run

The following sample run was performed on a MacBook Pro (Retina, 13-inch, Early 2015), 2.7 GHz Intel Core i5, 16 GB 1867 MHz DDR3.

The corresponding html report can be viewed at https://davidkellis.github.io/benchmarks/.

```
$ ./run.rb
Running binarytrees benchmark suite
  binarytrees/ruby2.5.1
  binarytrees/gcc8.1.0
  binarytrees/go1.10.3
  binarytrees/rust1.26.2

Running helloworld benchmark suite
  helloworld/ruby2.5.1
  helloworld/crystal0.25.0

Running base64 benchmark suite
  base64/ruby2.5.1
  base64/crystal0.25.0
  base64/rust1.26.2

Running matrixmultiply benchmark suite
  matrixmultiply/go1.10.3gonum
  matrixmultiply/ruby2.5.1
  matrixmultiply/go1.10.3

Running json benchmark suite
Running setup for json benchmark
  json/ruby2.5.1
  json/crystal0.25.0
Running teardown for json benchmark

Running pidigits benchmark suite
  pidigits/ruby2.5.1
  pidigits/crystal0.25.0
  pidigits/gcc8.1.0
  pidigits/go1.10.3
  pidigits/rust1.26.2

Running quicksort benchmark suite
Running setup for quicksort benchmark
  quicksort/ruby2.5.1
  quicksort/crystal0.25.0
Running teardown for quicksort benchmark

All benchmarks run in 511.381802 seconds.

Metrics (also written to index.html):
{"binarytrees:ruby2.5.1:process_user_time"=>"140.26",
 "binarytrees:ruby2.5.1:process_system_time"=>"3.05",
 "binarytrees:ruby2.5.1:process_real_time"=>"0:46.03",
 "binarytrees:ruby2.5.1:process_percent_cpu_time"=>"311%",
 "binarytrees:ruby2.5.1:process_max_rss_mb"=>411.49609375,
 "binarytrees:gcc8.1.0:process_user_time"=>"7.53",
 "binarytrees:gcc8.1.0:process_system_time"=>"0.21",
 "binarytrees:gcc8.1.0:process_real_time"=>"0:02.37",
 "binarytrees:gcc8.1.0:process_percent_cpu_time"=>"325%",
 "binarytrees:gcc8.1.0:process_max_rss_mb"=>130.984375,
 "binarytrees:go1.10.3:process_user_time"=>"92.16",
 "binarytrees:go1.10.3:process_system_time"=>"9.60",
 "binarytrees:go1.10.3:process_real_time"=>"0:31.37",
 "binarytrees:go1.10.3:process_percent_cpu_time"=>"324%",
 "binarytrees:go1.10.3:process_max_rss_mb"=>386.21875,
 "binarytrees:rust1.26.2:process_user_time"=>"9.55",
 "binarytrees:rust1.26.2:process_system_time"=>"2.52",
 "binarytrees:rust1.26.2:process_real_time"=>"0:03.36",
 "binarytrees:rust1.26.2:process_percent_cpu_time"=>"359%",
 "binarytrees:rust1.26.2:process_max_rss_mb"=>167.734375,
 "helloworld:ruby2.5.1:time"=>"1.74e-05s",
 "helloworld:ruby2.5.1:process_user_time"=>"0.05",
 "helloworld:ruby2.5.1:process_system_time"=>"0.02",
 "helloworld:ruby2.5.1:process_real_time"=>"0:00.10",
 "helloworld:ruby2.5.1:process_percent_cpu_time"=>"68%",
 "helloworld:ruby2.5.1:process_max_rss_mb"=>8.765625,
 "helloworld:crystal0.25.0:time"=>"00:00:00.000036000s",
 "helloworld:crystal0.25.0:process_user_time"=>"0.00",
 "helloworld:crystal0.25.0:process_system_time"=>"0.00",
 "helloworld:crystal0.25.0:process_real_time"=>"0:00.01",
 "helloworld:crystal0.25.0:process_percent_cpu_time"=>"0%",
 "helloworld:crystal0.25.0:process_max_rss_mb"=>2.98828125,
 "base64:ruby2.5.1:process_user_time"=>"3.03",
 "base64:ruby2.5.1:process_system_time"=>"0.36",
 "base64:ruby2.5.1:process_real_time"=>"0:03.40",
 "base64:ruby2.5.1:process_percent_cpu_time"=>"99%",
 "base64:ruby2.5.1:process_max_rss_mb"=>180.84375,
 "base64:crystal0.25.0:process_user_time"=>"2.53",
 "base64:crystal0.25.0:process_system_time"=>"0.02",
 "base64:crystal0.25.0:process_real_time"=>"0:02.57",
 "base64:crystal0.25.0:process_percent_cpu_time"=>"99%",
 "base64:crystal0.25.0:process_max_rss_mb"=>57.26953125,
 "base64:rust1.26.2:process_user_time"=>"1.94",
 "base64:rust1.26.2:process_system_time"=>"1.26",
 "base64:rust1.26.2:process_real_time"=>"0:03.21",
 "base64:rust1.26.2:process_percent_cpu_time"=>"99%",
 "base64:rust1.26.2:process_max_rss_mb"=>37.078125,
 "matrixmultiply:go1.10.3gonum:process_user_time"=>"0.97",
 "matrixmultiply:go1.10.3gonum:process_system_time"=>"0.01",
 "matrixmultiply:go1.10.3gonum:process_real_time"=>"0:00.33",
 "matrixmultiply:go1.10.3gonum:process_percent_cpu_time"=>"294%",
 "matrixmultiply:go1.10.3gonum:process_max_rss_mb"=>25.58203125,
 "matrixmultiply:ruby2.5.1:process_user_time"=>"262.24",
 "matrixmultiply:ruby2.5.1:process_system_time"=>"0.03",
 "matrixmultiply:ruby2.5.1:process_real_time"=>"4:22.63",
 "matrixmultiply:ruby2.5.1:process_percent_cpu_time"=>"99%",
 "matrixmultiply:ruby2.5.1:process_max_rss_mb"=>93.76171875,
 "matrixmultiply:go1.10.3:process_user_time"=>"17.36",
 "matrixmultiply:go1.10.3:process_system_time"=>"0.18",
 "matrixmultiply:go1.10.3:process_real_time"=>"0:17.52",
 "matrixmultiply:go1.10.3:process_percent_cpu_time"=>"100%",
 "matrixmultiply:go1.10.3:process_max_rss_mb"=>26.421875,
 "json:ruby2.5.1:time"=>"7.7473012s",
 "json:ruby2.5.1:process_user_time"=>"7.75",
 "json:ruby2.5.1:process_system_time"=>"0.60",
 "json:ruby2.5.1:process_real_time"=>"0:08.37",
 "json:ruby2.5.1:process_percent_cpu_time"=>"99%",
 "json:ruby2.5.1:process_max_rss_mb"=>805.09765625,
 "json:crystal0.25.0:time"=>"00:00:02.415821000s",
 "json:crystal0.25.0:process_user_time"=>"2.78",
 "json:crystal0.25.0:process_system_time"=>"0.50",
 "json:crystal0.25.0:process_real_time"=>"0:02.58",
 "json:crystal0.25.0:process_percent_cpu_time"=>"126%",
 "json:crystal0.25.0:process_max_rss_mb"=>1035.5234375,
 "pidigits:ruby2.5.1:process_user_time"=>"8.18",
 "pidigits:ruby2.5.1:process_system_time"=>"0.60",
 "pidigits:ruby2.5.1:process_real_time"=>"0:08.80",
 "pidigits:ruby2.5.1:process_percent_cpu_time"=>"99%",
 "pidigits:ruby2.5.1:process_max_rss_mb"=>158.4921875,
 "pidigits:crystal0.25.0:process_user_time"=>"8.09",
 "pidigits:crystal0.25.0:process_system_time"=>"2.26",
 "pidigits:crystal0.25.0:process_real_time"=>"0:10.16",
 "pidigits:crystal0.25.0:process_percent_cpu_time"=>"101%",
 "pidigits:crystal0.25.0:process_max_rss_mb"=>7.8359375,
 "pidigits:gcc8.1.0:process_user_time"=>"0.76",
 "pidigits:gcc8.1.0:process_system_time"=>"0.00",
 "pidigits:gcc8.1.0:process_real_time"=>"0:00.77",
 "pidigits:gcc8.1.0:process_percent_cpu_time"=>"98%",
 "pidigits:gcc8.1.0:process_max_rss_mb"=>2.125,
 "pidigits:go1.10.3:process_user_time"=>"1.23",
 "pidigits:go1.10.3:process_system_time"=>"0.06",
 "pidigits:go1.10.3:process_real_time"=>"0:01.26",
 "pidigits:go1.10.3:process_percent_cpu_time"=>"101%",
 "pidigits:go1.10.3:process_max_rss_mb"=>9.01953125,
 "pidigits:rust1.26.2:process_user_time"=>"0.76",
 "pidigits:rust1.26.2:process_system_time"=>"0.00",
 "pidigits:rust1.26.2:process_real_time"=>"0:00.76",
 "pidigits:rust1.26.2:process_percent_cpu_time"=>"99%",
 "pidigits:rust1.26.2:process_max_rss_mb"=>4.40234375,
 "quicksort:ruby2.5.1:process_user_time"=>"4.21",
 "quicksort:ruby2.5.1:process_system_time"=>"0.08",
 "quicksort:ruby2.5.1:process_real_time"=>"0:04.30",
 "quicksort:ruby2.5.1:process_percent_cpu_time"=>"99%",
 "quicksort:ruby2.5.1:process_max_rss_mb"=>151.21484375,
 "quicksort:crystal0.25.0:process_user_time"=>"1.78",
 "quicksort:crystal0.25.0:process_system_time"=>"0.16",
 "quicksort:crystal0.25.0:process_real_time"=>"0:01.65",
 "quicksort:crystal0.25.0:process_percent_cpu_time"=>"117%",
 "quicksort:crystal0.25.0:process_max_rss_mb"=>103.734375}
```