FROM python:3.6.5

RUN apt-get update && apt-get install -y time

WORKDIR /app

# keep in mind that the docker build command is being run from the benchmarks/ project's root directory
# and the context directory is being specified as the benchmarks/ root directory
COPY time.sh .
COPY tapelang-alphabet/benchmark.tape .
COPY tapelang-alphabet/python3.6.5/run.py .

CMD ["./time.sh", "python", "run.py", "benchmark.tape"]