FROM gcc:15
RUN apt-get update && apt-get install -y time

WORKDIR /app
COPY time.sh .
COPY sudoku/sudoku.txt .
COPY sudoku/gcc-15/run.c .

RUN gcc -pipe -Wall -O3 -fomit-frame-pointer -march=native run.c -o app

CMD ["./time.sh","./app"]
