FROM crystallang/crystal:latest

RUN apt-get update && apt-get install time

WORKDIR /app

# keep in mind that the docker build command is being run from the benchmarks/ project's root directory
# and the context directory is being specified as the benchmarks/ root directory
COPY time.sh .
COPY matrixmultiply/crystal/run.cr .

RUN crystal build run.cr --release

CMD ["./time.sh", "./run", "1000"]
