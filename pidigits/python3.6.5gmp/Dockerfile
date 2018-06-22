FROM python:3.6.5

RUN apt-get update && apt-get install -y time libgmp-dev libmpfr-dev libmpc-dev

WORKDIR /app

# keep in mind that the docker build command is being run from the benchmarks/ project's root directory
# and the context directory is being specified as the benchmarks/ root directory
COPY time.sh .
COPY pidigits/python3.6.5gmp/run.py .

RUN pip install gmpy2

CMD ["./time.sh", "python", "run.py", "10000"]