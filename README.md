# benchmarks

This project aims to replicate a variety of benchmarks taken from various sources.

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

```
$ ./run.rb
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
  pidigits/go1.10.3

Metrics:
{"helloworld:ruby2.5.1:time"=>"1.66e-05s",
 "helloworld:ruby2.5.1:process_user_time"=>"0.04",
 "helloworld:ruby2.5.1:process_system_time"=>"0.02",
 "helloworld:ruby2.5.1:process_real_time"=>"0:00.06",
 "helloworld:ruby2.5.1:process_percent_cpu_time"=>"90%",
 "helloworld:ruby2.5.1:process_max_rss_mb"=>8.5078125,
 "helloworld:ruby2.5.1:process_avg_rss_mb"=>0.0,
 "helloworld:ruby2.5.1:process_avg_total_mem_mb"=>0.0,
 "helloworld:crystal0.25.0:process_user_time"=>"0.00",
 "helloworld:crystal0.25.0:process_system_time"=>"0.00",
 "helloworld:crystal0.25.0:process_real_time"=>"0:00.00",
 "helloworld:crystal0.25.0:process_percent_cpu_time"=>"0%",
 "helloworld:crystal0.25.0:process_max_rss_mb"=>3.109375,
 "helloworld:crystal0.25.0:process_avg_rss_mb"=>0.0,
 "helloworld:crystal0.25.0:process_avg_total_mem_mb"=>0.0,
 "helloworld:crystal0.25.0:time"=>"00:00:00.000027000s",
 "base64:ruby2.5.1:time"=>"2.6429187s",
 "base64:ruby2.5.1:process_user_time"=>"2.54",
 "base64:ruby2.5.1:process_system_time"=>"0.19",
 "base64:ruby2.5.1:process_real_time"=>"0:02.74",
 "base64:ruby2.5.1:process_percent_cpu_time"=>"99%",
 "base64:ruby2.5.1:process_max_rss_mb"=>193.265625,
 "base64:ruby2.5.1:process_avg_rss_mb"=>0.0,
 "base64:ruby2.5.1:process_avg_total_mem_mb"=>0.0,
 "base64:crystal0.25.0:process_user_time"=>"2.16",
 "base64:crystal0.25.0:process_system_time"=>"0.03",
 "base64:crystal0.25.0:process_real_time"=>"0:02.22",
 "base64:crystal0.25.0:process_percent_cpu_time"=>"98%",
 "base64:crystal0.25.0:process_max_rss_mb"=>54.14453125,
 "base64:crystal0.25.0:process_avg_rss_mb"=>0.0,
 "base64:crystal0.25.0:process_avg_total_mem_mb"=>0.0,
 "json:ruby2.5.1:time"=>"7.2558353s",
 "json:ruby2.5.1:process_user_time"=>"7.18",
 "json:ruby2.5.1:process_system_time"=>"0.65",
 "json:ruby2.5.1:process_real_time"=>"0:07.86",
 "json:ruby2.5.1:process_percent_cpu_time"=>"99%",
 "json:ruby2.5.1:process_max_rss_mb"=>815.3203125,
 "json:ruby2.5.1:process_avg_rss_mb"=>0.0,
 "json:ruby2.5.1:process_avg_total_mem_mb"=>0.0,
 "json:crystal0.25.0:time"=>"00:00:02.415149000s",
 "json:crystal0.25.0:process_user_time"=>"2.35",
 "json:crystal0.25.0:process_system_time"=>"0.48",
 "json:crystal0.25.0:process_real_time"=>"0:02.58",
 "json:crystal0.25.0:process_percent_cpu_time"=>"109%",
 "json:crystal0.25.0:process_max_rss_mb"=>1035.578125,
 "json:crystal0.25.0:process_avg_rss_mb"=>0.0,
 "json:crystal0.25.0:process_avg_total_mem_mb"=>0.0,
 "pidigits:ruby2.5.1:process_user_time"=>"8.01",
 "pidigits:ruby2.5.1:process_system_time"=>"0.56",
 "pidigits:ruby2.5.1:process_real_time"=>"0:08.61",
 "pidigits:ruby2.5.1:process_percent_cpu_time"=>"99%",
 "pidigits:ruby2.5.1:process_max_rss_mb"=>158.52734375,
 "pidigits:ruby2.5.1:process_avg_rss_mb"=>0.0,
 "pidigits:ruby2.5.1:process_avg_total_mem_mb"=>0.0,
 "pidigits:crystal0.25.0:process_user_time"=>"6.79",
 "pidigits:crystal0.25.0:process_system_time"=>"1.21",
 "pidigits:crystal0.25.0:process_real_time"=>"0:08.81",
 "pidigits:crystal0.25.0:process_percent_cpu_time"=>"90%",
 "pidigits:crystal0.25.0:process_max_rss_mb"=>9.42578125,
 "pidigits:crystal0.25.0:process_avg_rss_mb"=>0.0,
 "pidigits:crystal0.25.0:process_avg_total_mem_mb"=>0.0,
 "pidigits:go1.10.3:process_user_time"=>"1.30",
 "pidigits:go1.10.3:process_system_time"=>"0.03",
 "pidigits:go1.10.3:process_real_time"=>"0:01.32",
 "pidigits:go1.10.3:process_percent_cpu_time"=>"100%",
 "pidigits:go1.10.3:process_max_rss_mb"=>8.953125,
 "pidigits:go1.10.3:process_avg_rss_mb"=>0.0,
 "pidigits:go1.10.3:process_avg_total_mem_mb"=>0.0}
```