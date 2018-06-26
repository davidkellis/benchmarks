FROM rust:1.26.2

RUN apt-get update && apt-get install -y time

WORKDIR /matmul

# keep in mind that the docker build command is being run from the benchmarks/ project's root directory
# and the context directory is being specified as the benchmarks/ root directory
COPY time.sh .
COPY matrixmultiply/rust1.26.2/ ./

RUN cargo install

CMD ["./time.sh", "matmul", "1000"]
