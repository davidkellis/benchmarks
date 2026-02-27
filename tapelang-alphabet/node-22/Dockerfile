FROM node:22
RUN apt-get update && apt-get install -y time

WORKDIR /app
COPY time.sh .
COPY tapelang-alphabet/benchmark.tape .
COPY tapelang-alphabet/node-22/run.js .

RUN npm install readline-sync

CMD ["./time.sh","node","run.js","benchmark.tape"]
