FROM gcc:13
RUN apt-get update && apt-get install -y time libopenmpi-dev libapr1 libapr1-dev

WORKDIR /app
COPY time.sh .
COPY binarytrees/gcc-13/run.c .

RUN gcc -pipe -Wall -O3 -fomit-frame-pointer -march=native -fopenmp -D_FILE_OFFSET_BITS=64 -I/usr/include/apr-1.0 run.c -o app -lapr-1 -lgomp -lm

CMD ["./time.sh","./app","21"]
