FROM thevlang/vlang:latest

RUN apk update && apk add bash
RUN apk add time --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing   # we need gnu time

WORKDIR /app

# keep in mind that the docker build command is being run from the benchmarks/ project's root directory
# and the context directory is being specified as the benchmarks/ root directory
COPY time.sh .
COPY json/sample.json .
COPY json/vlang/*.v .

RUN v run.v

CMD ["./time.sh", "./run"]
