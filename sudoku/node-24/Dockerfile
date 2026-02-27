FROM node:24
RUN apt-get update && apt-get install -y time

WORKDIR /app
COPY time.sh .
COPY sudoku/sudoku.txt .
COPY sudoku/node-24/run.js .

CMD ["./time.sh","node","run.js"]
