FROM golang:latest

RUN apt-get update && apt-get install -y time

WORKDIR /go/src/app

# keep in mind that the docker build command is being run from the benchmarks/ project's root directory
# and the context directory is being specified as the benchmarks/ root directory
COPY time.sh .
COPY quicksort/numbers.txt .
COPY quicksort/go/*.go .

RUN go build app.go

CMD ["./time.sh", "./app"]
