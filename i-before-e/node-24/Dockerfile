FROM node:24
RUN apt-get update && apt-get install -y time

WORKDIR /app
COPY time.sh .
COPY i-before-e/wordlist.txt .
COPY i-before-e/node-24/run.js .

CMD ["./time.sh","node","run.js","wordlist.txt"]
