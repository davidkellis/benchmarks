FROM gcc:8.1.0

RUN apt-get update && apt-get install -y time libgmp-dev

WORKDIR /app

# keep in mind that the docker build command is being run from the benchmarks/ project's root directory
# and the context directory is being specified as the benchmarks/ root directory
COPY time.sh .
COPY pidigits/gcc8.1.0gmp/*.c .

RUN gcc -pipe -Wall -O3 -fomit-frame-pointer -march=native run.c -o app -lgmp

CMD ["./time.sh", "./app", "10000"]