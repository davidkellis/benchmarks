FROM gcc:13
RUN apt-get update && apt-get install -y time

WORKDIR /app
COPY time.sh .
COPY fib/gcc-13/run.c .

RUN gcc -pipe -Wall -O3 -fomit-frame-pointer -march=native -fopenmp -D_FILE_OFFSET_BITS=64 run.c -o app

CMD ["./time.sh","./app"]
