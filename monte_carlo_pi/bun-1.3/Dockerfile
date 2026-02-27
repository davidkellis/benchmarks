FROM oven/bun:1.3
RUN apt-get update && apt-get install -y time

WORKDIR /app
COPY time.sh .
COPY monte_carlo_pi/bun-1.3/run.ts .

CMD ["./time.sh","bun","run","run.ts"]
