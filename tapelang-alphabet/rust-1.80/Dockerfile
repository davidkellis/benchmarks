FROM rust:1.80
RUN apt-get update && apt-get install -y time

WORKDIR /app
COPY time.sh .
COPY tapelang-alphabet/benchmark.tape .
COPY tapelang-alphabet/rust-1.80/ .

RUN cargo build --release

CMD ["./time.sh","./target/release/tapelang_alphabet","benchmark.tape"]
