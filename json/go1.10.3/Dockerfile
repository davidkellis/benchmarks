FROM golang:1.10

RUN apt-get update && apt-get install -y time

WORKDIR /go/src/app

# keep in mind that the docker build command is being run from the benchmarks/ project's root directory
# and the context directory is being specified as the benchmarks/ root directory
COPY time.sh .
COPY json/sample.json .
COPY json/go1.10.3/*.go .

RUN go install .

CMD ["./time.sh", "app"]