FROM rust:1.80
RUN apt-get update && apt-get install -y time libgmp-dev

WORKDIR /app
COPY time.sh .
COPY pidigits/rust-1.80-gmp/ .

RUN cargo build --release

CMD ["./time.sh","./target/release/pidigits","10000"]
