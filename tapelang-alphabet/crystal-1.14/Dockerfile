FROM crystallang/crystal:1.14
RUN apt-get update && apt-get install -y time

WORKDIR /app
COPY time.sh .
COPY tapelang-alphabet/benchmark.tape .
COPY tapelang-alphabet/crystal-1.14/run.cr .

RUN crystal build run.cr --release

CMD ["./time.sh","./run","benchmark.tape"]
