FROM gcc:latest

RUN apt-get update && apt-get install -y time libblas-dev gfortran-

WORKDIR /app

# keep in mind that the docker build command is being run from the benchmarks/ project's root directory
# and the context directory is being specified as the benchmarks/ root directory
COPY time.sh .
COPY sudoku/sudoku.txt .
COPY sudoku/gcc/*.c .

RUN gcc -pipe -Wall -O3 -fomit-frame-pointer -march=native run.c -o app

CMD ["./time.sh", "./app"]
