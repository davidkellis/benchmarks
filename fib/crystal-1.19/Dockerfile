FROM crystallang/crystal:1.19
RUN apt-get update && apt-get install -y time

WORKDIR /app
COPY time.sh .
COPY fib/crystal-1.19/run.cr .

RUN crystal build run.cr --release

CMD ["./time.sh","./run"]
