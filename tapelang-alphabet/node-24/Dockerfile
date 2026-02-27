FROM node:24
RUN apt-get update && apt-get install -y time

WORKDIR /app
COPY time.sh .
COPY tapelang-alphabet/benchmark.tape .
COPY tapelang-alphabet/node-24/run.js .

RUN npm install readline-sync

CMD ["./time.sh","node","run.js","benchmark.tape"]
