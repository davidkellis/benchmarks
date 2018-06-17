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

Running helloworld benchmark suite
  helloworld/ruby2.5.1
  helloworld/crystal0.25.0

Running base64 benchmark suite
  base64/ruby2.5.1
  base64/crystal0.25.0

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

Metrics (also written to metrics.html):
{"binarytrees:ruby2.5.1:process_user_time"=>"137.46",
 "binarytrees:ruby2.5.1:process_system_time"=>"3.24",
 "binarytrees:ruby2.5.1:process_real_time"=>"0:44.36",
 "binarytrees:ruby2.5.1:process_percent_cpu_time"=>"317%",
 "binarytrees:ruby2.5.1:process_max_rss_mb"=>411.93359375,
 "binarytrees:gcc8.1.0:process_user_time"=>"7.72",
 "binarytrees:gcc8.1.0:process_system_time"=>"0.24",
 "binarytrees:gcc8.1.0:process_real_time"=>"0:02.35",
 "binarytrees:gcc8.1.0:process_percent_cpu_time"=>"338%",
 "binarytrees:gcc8.1.0:process_max_rss_mb"=>130.98046875,
 "binarytrees:go1.10.3:process_user_time"=>"90.20",
 "binarytrees:go1.10.3:process_system_time"=>"12.08",
 "binarytrees:go1.10.3:process_real_time"=>"0:32.05",
 "binarytrees:go1.10.3:process_percent_cpu_time"=>"319%",
 "binarytrees:go1.10.3:process_max_rss_mb"=>386.3046875,
 "helloworld:ruby2.5.1:time"=>"1.94e-05s",
 "helloworld:ruby2.5.1:process_user_time"=>"0.08",
 "helloworld:ruby2.5.1:process_system_time"=>"0.00",
 "helloworld:ruby2.5.1:process_real_time"=>"0:00.11",
 "helloworld:ruby2.5.1:process_percent_cpu_time"=>"67%",
 "helloworld:ruby2.5.1:process_max_rss_mb"=>8.73046875,
 "helloworld:crystal0.25.0:process_user_time"=>"0.00",
 "helloworld:crystal0.25.0:process_system_time"=>"0.00",
 "helloworld:crystal0.25.0:process_real_time"=>"0:00.00",
 "helloworld:crystal0.25.0:process_percent_cpu_time"=>"0%",
 "helloworld:crystal0.25.0:process_max_rss_mb"=>3.0625,
 "helloworld:crystal0.25.0:time"=>"00:00:00.000017000s",
 "base64:ruby2.5.1:time"=>"2.5437507s",
 "base64:ruby2.5.1:process_user_time"=>"2.54",
 "base64:ruby2.5.1:process_system_time"=>"0.09",
 "base64:ruby2.5.1:process_real_time"=>"0:02.64",
 "base64:ruby2.5.1:process_percent_cpu_time"=>"99%",
 "base64:ruby2.5.1:process_max_rss_mb"=>196.59375,
 "base64:crystal0.25.0:process_user_time"=>"1.96",
 "base64:crystal0.25.0:process_system_time"=>"0.05",
 "base64:crystal0.25.0:process_real_time"=>"0:02.01",
 "base64:crystal0.25.0:process_percent_cpu_time"=>"99%",
 "base64:crystal0.25.0:process_max_rss_mb"=>60.734375,
 "json:ruby2.5.1:time"=>"7.5525335s",
 "json:ruby2.5.1:process_user_time"=>"7.58",
 "json:ruby2.5.1:process_system_time"=>"0.52",
 "json:ruby2.5.1:process_real_time"=>"0:08.12",
 "json:ruby2.5.1:process_percent_cpu_time"=>"99%",
 "json:ruby2.5.1:process_max_rss_mb"=>814.6953125,
 "json:crystal0.25.0:time"=>"00:00:02.500144000s",
 "json:crystal0.25.0:process_user_time"=>"2.68",
 "json:crystal0.25.0:process_system_time"=>"0.56",
 "json:crystal0.25.0:process_real_time"=>"0:02.70",
 "json:crystal0.25.0:process_percent_cpu_time"=>"119%",
 "json:crystal0.25.0:process_max_rss_mb"=>1035.5390625,
 "pidigits:ruby2.5.1:process_user_time"=>"7.76",
 "pidigits:ruby2.5.1:process_system_time"=>"0.68",
 "pidigits:ruby2.5.1:process_real_time"=>"0:08.48",
 "pidigits:ruby2.5.1:process_percent_cpu_time"=>"99%",
 "pidigits:ruby2.5.1:process_max_rss_mb"=>158.6328125,
 "pidigits:crystal0.25.0:process_user_time"=>"7.60",
 "pidigits:crystal0.25.0:process_system_time"=>"2.00",
 "pidigits:crystal0.25.0:process_real_time"=>"0:09.22",
 "pidigits:crystal0.25.0:process_percent_cpu_time"=>"104%",
 "pidigits:crystal0.25.0:process_max_rss_mb"=>9.5234375,
 "pidigits:gcc8.1.0:process_user_time"=>"0.77",
 "pidigits:gcc8.1.0:process_system_time"=>"0.00",
 "pidigits:gcc8.1.0:process_real_time"=>"0:00.78",
 "pidigits:gcc8.1.0:process_percent_cpu_time"=>"98%",
 "pidigits:gcc8.1.0:process_max_rss_mb"=>2.171875,
 "pidigits:go1.10.3:process_user_time"=>"1.32",
 "pidigits:go1.10.3:process_system_time"=>"0.02",
 "pidigits:go1.10.3:process_real_time"=>"0:01.32",
 "pidigits:go1.10.3:process_percent_cpu_time"=>"101%",
 "pidigits:go1.10.3:process_max_rss_mb"=>9.22265625}
```