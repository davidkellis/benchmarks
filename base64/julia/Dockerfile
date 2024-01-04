FROM julia:latest

RUN apt-get update && apt-get install time

WORKDIR /app

# keep in mind that the docker build command is being run from the benchmarks/ project's root directory
# and the context directory is being specified as the benchmarks/ root directory
COPY time.sh .
COPY base64/julia/run.jl .

RUN julia -e 'using Pkg; Pkg.add("Codecs")'
RUN julia -e 'using Pkg; Pkg.add("MD5")'

CMD ["./time.sh", "julia", "run.jl"]
