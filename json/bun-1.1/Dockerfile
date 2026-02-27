FROM oven/bun:1.1
RUN apt-get update && apt-get install -y time

WORKDIR /app
COPY time.sh .
COPY json/sample.json .
COPY json/bun-1.1/run.ts .

CMD ["./time.sh","bun","run","run.ts"]
