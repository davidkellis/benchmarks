FROM julia:0.6.3

RUN apt-get update && apt-get install time

WORKDIR /app

# keep in mind that the docker build command is being run from the benchmarks/ project's root directory
# and the context directory is being specified as the benchmarks/ root directory
COPY time.sh .
COPY json/sample.json .
COPY json/julia0.6.3/run.jl .

RUN julia -e 'Pkg.add("JSON")'

CMD ["./time.sh", "julia", "run.jl"]