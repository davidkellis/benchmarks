FROM rust:1.93
RUN apt-get update && apt-get install -y time

WORKDIR /app
COPY time.sh .
COPY monte_carlo_pi/rust-1.93/ .

RUN cargo build --release

CMD ["./time.sh","./target/release/monte_carlo_pi"]
