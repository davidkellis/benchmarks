FROM node:10.5.0

RUN apt-get update && apt-get install -y time

WORKDIR /app

# keep in mind that the docker build command is being run from the benchmarks/ project's root directory
# and the context directory is being specified as the benchmarks/ root directory
COPY time.sh .
COPY tapelang-alphabet/benchmark.tape .
COPY tapelang-alphabet/javascript-node10.5.0/run.js .

RUN npm install readline-sync

CMD ["./time.sh", "node", "run.js", "benchmark.tape"]