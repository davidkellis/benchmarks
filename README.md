# benchmarks

This project aims to replicate a variety of benchmarks taken from various sources.

A sample benchmark report run on a MacBook Pro (Retina, 13-inch, Early 2015, 2.7 GHz Intel Core i5, 16 GB 1867 MHz DDR3) can be seen at https://davidkellis.github.io/benchmarks/.

Every benchmark implementation runs in a self-contained Docker container. Necessary build and runtime artifacts are copied into the container.

Benchmarks are pulled from:
- https://benchmarksgame-team.pages.debian.net/benchmarksgame/
- https://github.com/kostya/benchmarks
- https://github.com/kostya/crystal-benchmarks-game
- https://github.com/trizen/language-benchmarks
- https://github.com/JuliaLang/Microbenchmarks


## How to run all benchmarks

1. Install Docker Community Edition (see https://store.docker.com/search?type=edition&offering=community)
2. Install Ruby 2.0+
3. `git clone git@github.com:davidkellis/benchmarks.git`
4. `cd benchmarks`
5. `./run.rb`
6. Open ./metrics.html in a web browser to view the results.


## How to add benchmarks

Every directory in the top level project directory corresponds to a benchmark suite. For example:
```
benchmarks
- base64
- helloworld
- json
- pidigits
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

All benchmarks run in 946.089122 seconds.

Metrics (also written to index.html):
{"binarytrees:ruby2.5.1:process_user_time"=>"141.75",
 "binarytrees:ruby2.5.1:process_system_time"=>"2.76",
 "binarytrees:ruby2.5.1:process_real_time"=>"0:45.73",
 "binarytrees:ruby2.5.1:process_percent_cpu_time"=>"315%",
 "binarytrees:ruby2.5.1:process_max_rss_mb"=>411.89453125,
 "binarytrees:gcc8.1.0:process_user_time"=>"7.28",
 "binarytrees:gcc8.1.0:process_system_time"=>"0.28",
 "binarytrees:gcc8.1.0:process_real_time"=>"0:02.26",
 "binarytrees:gcc8.1.0:process_percent_cpu_time"=>"333%",
 "binarytrees:gcc8.1.0:process_max_rss_mb"=>131.0625,
 "binarytrees:go1.10.3:process_user_time"=>"96.03",
 "binarytrees:go1.10.3:process_system_time"=>"12.58",
 "binarytrees:go1.10.3:process_real_time"=>"0:33.87",
 "binarytrees:go1.10.3:process_percent_cpu_time"=>"320%",
 "binarytrees:go1.10.3:process_max_rss_mb"=>377.7421875,
 "binarytrees:rust1.26.2:process_user_time"=>"10.56",
 "binarytrees:rust1.26.2:process_system_time"=>"3.13",
 "binarytrees:rust1.26.2:process_real_time"=>"0:03.72",
 "binarytrees:rust1.26.2:process_percent_cpu_time"=>"367%",
 "binarytrees:rust1.26.2:process_max_rss_mb"=>163.53515625,
 "helloworld:ruby2.5.1:time"=>"1.51e-05s",
 "helloworld:ruby2.5.1:process_user_time"=>"0.07",
 "helloworld:ruby2.5.1:process_system_time"=>"0.01",
 "helloworld:ruby2.5.1:process_real_time"=>"0:00.12",
 "helloworld:ruby2.5.1:process_percent_cpu_time"=>"66%",
 "helloworld:ruby2.5.1:process_max_rss_mb"=>8.875,
 "helloworld:crystal0.25.0:time"=>"00:00:00.000029000s",
 "helloworld:crystal0.25.0:process_user_time"=>"0.00",
 "helloworld:crystal0.25.0:process_system_time"=>"0.00",
 "helloworld:crystal0.25.0:process_real_time"=>"0:00.00",
 "helloworld:crystal0.25.0:process_percent_cpu_time"=>"0%",
 "helloworld:crystal0.25.0:process_max_rss_mb"=>3.078125,
 "base64:ruby2.5.1:process_user_time"=>"2.83",
 "base64:ruby2.5.1:process_system_time"=>"0.21",
 "base64:ruby2.5.1:process_real_time"=>"0:03.09",
 "base64:ruby2.5.1:process_percent_cpu_time"=>"98%",
 "base64:ruby2.5.1:process_max_rss_mb"=>183.5,
 "base64:crystal0.25.0:process_user_time"=>"2.54",
 "base64:crystal0.25.0:process_system_time"=>"0.05",
 "base64:crystal0.25.0:process_real_time"=>"0:02.60",
 "base64:crystal0.25.0:process_percent_cpu_time"=>"99%",
 "base64:crystal0.25.0:process_max_rss_mb"=>70.59375,
 "base64:rust1.26.2:process_user_time"=>"1.76",
 "base64:rust1.26.2:process_system_time"=>"1.27",
 "base64:rust1.26.2:process_real_time"=>"0:03.04",
 "base64:rust1.26.2:process_percent_cpu_time"=>"99%",
 "base64:rust1.26.2:process_max_rss_mb"=>37.02734375,
 "matrixmultiply:go1.10.3gonum:process_user_time"=>"1.06",
 "matrixmultiply:go1.10.3gonum:process_system_time"=>"0.01",
 "matrixmultiply:go1.10.3gonum:process_real_time"=>"0:00.33",
 "matrixmultiply:go1.10.3gonum:process_percent_cpu_time"=>"323%",
 "matrixmultiply:go1.10.3gonum:process_max_rss_mb"=>25.578125,
 "matrixmultiply:ruby2.5.1:process_user_time"=>"273.31",
 "matrixmultiply:ruby2.5.1:process_system_time"=>"0.02",
 "matrixmultiply:ruby2.5.1:process_real_time"=>"4:33.73",
 "matrixmultiply:ruby2.5.1:process_percent_cpu_time"=>"99%",
 "matrixmultiply:ruby2.5.1:process_max_rss_mb"=>97.16796875,
 "matrixmultiply:go1.10.3:process_user_time"=>"17.41",
 "matrixmultiply:go1.10.3:process_system_time"=>"0.24",
 "matrixmultiply:go1.10.3:process_real_time"=>"0:17.57",
 "matrixmultiply:go1.10.3:process_percent_cpu_time"=>"100%",
 "matrixmultiply:go1.10.3:process_max_rss_mb"=>26.484375,
 "json:ruby2.5.1:time"=>"7.8134061s",
 "json:ruby2.5.1:process_user_time"=>"8.00",
 "json:ruby2.5.1:process_system_time"=>"0.45",
 "json:ruby2.5.1:process_real_time"=>"0:08.48",
 "json:ruby2.5.1:process_percent_cpu_time"=>"99%",
 "json:ruby2.5.1:process_max_rss_mb"=>815.83203125,
 "json:crystal0.25.0:time"=>"00:00:02.808122000s",
 "json:crystal0.25.0:process_user_time"=>"3.04",
 "json:crystal0.25.0:process_system_time"=>"0.54",
 "json:crystal0.25.0:process_real_time"=>"0:03.04",
 "json:crystal0.25.0:process_percent_cpu_time"=>"117%",
 "json:crystal0.25.0:process_max_rss_mb"=>1035.625,
 "pidigits:ruby2.5.1:process_user_time"=>"8.21",
 "pidigits:ruby2.5.1:process_system_time"=>"0.85",
 "pidigits:ruby2.5.1:process_real_time"=>"0:09.21",
 "pidigits:ruby2.5.1:process_percent_cpu_time"=>"98%",
 "pidigits:ruby2.5.1:process_max_rss_mb"=>158.76171875,
 "pidigits:crystal0.25.0:process_user_time"=>"7.99",
 "pidigits:crystal0.25.0:process_system_time"=>"1.76",
 "pidigits:crystal0.25.0:process_real_time"=>"0:09.27",
 "pidigits:crystal0.25.0:process_percent_cpu_time"=>"105%",
 "pidigits:crystal0.25.0:process_max_rss_mb"=>7.92578125,
 "pidigits:gcc8.1.0:process_user_time"=>"0.77",
 "pidigits:gcc8.1.0:process_system_time"=>"0.00",
 "pidigits:gcc8.1.0:process_real_time"=>"0:00.78",
 "pidigits:gcc8.1.0:process_percent_cpu_time"=>"97%",
 "pidigits:gcc8.1.0:process_max_rss_mb"=>2.21875,
 "pidigits:go1.10.3:process_user_time"=>"1.21",
 "pidigits:go1.10.3:process_system_time"=>"0.04",
 "pidigits:go1.10.3:process_real_time"=>"0:01.23",
 "pidigits:go1.10.3:process_percent_cpu_time"=>"100%",
 "pidigits:go1.10.3:process_max_rss_mb"=>9.05078125,
 "pidigits:rust1.26.2:process_user_time"=>"0.76",
 "pidigits:rust1.26.2:process_system_time"=>"0.01",
 "pidigits:rust1.26.2:process_real_time"=>"0:00.78",
 "pidigits:rust1.26.2:process_percent_cpu_time"=>"98%",
 "pidigits:rust1.26.2:process_max_rss_mb"=>4.41796875}
```