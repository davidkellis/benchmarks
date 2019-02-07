FROM crystallang/crystal:0.25.0

RUN apt-get update && apt-get install -y time

WORKDIR /app

# keep in mind that the docker build command is being run from the benchmarks/ project's root directory
# and the context directory is being specified as the benchmarks/ root directory
COPY time.sh .
COPY i-before-e/wordlist.txt .
COPY i-before-e/crystal0.25.0/run.cr .

RUN crystal build run.cr --release

CMD ["./time.sh", "./run", "wordlist.txt"]