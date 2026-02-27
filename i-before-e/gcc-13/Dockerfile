FROM gcc:13
RUN apt-get update && apt-get install -y time

WORKDIR /app
COPY time.sh .
COPY i-before-e/wordlist.txt .
COPY i-before-e/gcc-13/run.c .

RUN gcc -pipe -Wall -O3 -fomit-frame-pointer -march=native run.c -o app -lm

CMD ["./time.sh","./app","wordlist.txt"]
