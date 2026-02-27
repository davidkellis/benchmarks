FROM crystallang/crystal:1.14
RUN apt-get update && apt-get install -y time

WORKDIR /app
COPY time.sh .
COPY monte_carlo_pi/crystal-1.14/run.cr .

RUN crystal build run.cr --release

CMD ["./time.sh","./run"]
