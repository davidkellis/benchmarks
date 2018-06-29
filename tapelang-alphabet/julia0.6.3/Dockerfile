FROM julia:0.6.3

RUN apt-get update && apt-get install time

WORKDIR /app

# keep in mind that the docker build command is being run from the benchmarks/ project's root directory
# and the context directory is being specified as the benchmarks/ root directory
COPY time.sh .
COPY tapelang-alphabet/benchmark.tape .
COPY tapelang-alphabet/julia0.6.3/run.jl .

CMD ["./time.sh", "julia", "run.jl", "benchmark.tape"]