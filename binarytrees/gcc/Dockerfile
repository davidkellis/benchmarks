FROM gcc:latest

RUN apt-get update && apt-get install -y time libopenmpi-dev libapr1 libapr1-dev libblas-dev gfortran-

WORKDIR /app

# keep in mind that the docker build command is being run from the benchmarks/ project's root directory
# and the context directory is being specified as the benchmarks/ root directory
COPY time.sh .
COPY binarytrees/gcc/*.c .

RUN gcc -pipe -Wall -O3 -fomit-frame-pointer -march=native -fopenmp -D_FILE_OFFSET_BITS=64 -I/usr/include/apr-1.0 run.c -o app -lapr-1 -lgomp -lm

CMD ["./time.sh", "./app", "21"]
