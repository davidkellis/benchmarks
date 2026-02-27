FROM gcc:15
RUN apt-get update && apt-get install -y time libssl-dev

WORKDIR /app
COPY time.sh .
COPY base64/gcc-15/run.c .

RUN gcc -pipe -Wall -O3 -fomit-frame-pointer -march=native -fopenmp -D_FILE_OFFSET_BITS=64 -I/usr/include/openssl run.c -o app -lcrypto

CMD ["./time.sh","./app"]
