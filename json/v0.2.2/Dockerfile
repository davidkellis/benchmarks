FROM ubuntu:21.04

RUN apt-get update && apt-get install -y time
RUN apt-get install -y build-essential            # c compiler suite
RUN apt-get install -y wget
RUN apt-get install -y unzip

WORKDIR /app

RUN wget https://github.com/vlang/v/releases/download/0.2.2/v_linux.zip
RUN unzip v_linux.zip     # unzips into /app/v

# keep in mind that the docker build command is being run from the benchmarks/ project's root directory
# and the context directory is being specified as the benchmarks/ root directory
COPY time.sh .
COPY json/sample.json .
COPY json/v0.2.2/*.v .

RUN v/v run.v

CMD ["./time.sh", "./run"]
