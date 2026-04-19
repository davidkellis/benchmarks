FROM able-v12-base AS builder

COPY fib/able-v12-compiled/run.able .
RUN able build run.able

FROM able-v12-base
COPY time.sh .
COPY --from=builder /app/target/compiled/run ./run
CMD ["./time.sh", "./run"]
