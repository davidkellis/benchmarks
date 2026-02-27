FROM rust:1.80
RUN apt-get update && apt-get install -y time

WORKDIR /app
COPY time.sh .
COPY json/sample.json .
COPY json/rust-1.80/ .

RUN cargo build --release

CMD ["./time.sh","./target/release/json"]
