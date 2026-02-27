FROM gcc:15
RUN apt-get update && apt-get install -y time libgmp-dev libgmp-dev

WORKDIR /app
COPY time.sh .
COPY pidigits/gcc-15-gmp/run.c .

RUN gcc -pipe -Wall -O3 -fomit-frame-pointer -march=native run.c -o app -lgmp

CMD ["./time.sh","./app","10000"]
