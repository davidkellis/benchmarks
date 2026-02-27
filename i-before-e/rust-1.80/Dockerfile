FROM rust:1.80
RUN apt-get update && apt-get install -y time

WORKDIR /app
COPY time.sh .
COPY i-before-e/wordlist.txt .
COPY i-before-e/rust-1.80/ .

RUN cargo build --release

CMD ["./time.sh","./target/release/app","wordlist.txt"]
