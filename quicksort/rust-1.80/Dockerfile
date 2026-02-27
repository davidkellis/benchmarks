FROM rust:1.80
RUN apt-get update && apt-get install -y time

WORKDIR /app
COPY time.sh .
COPY quicksort/numbers.txt .
COPY quicksort/rust-1.80/ .

RUN cargo build --release

CMD ["./time.sh","./target/release/quicksort"]
