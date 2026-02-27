FROM python:3.12
RUN apt-get update && apt-get install -y time

WORKDIR /app
COPY time.sh .
COPY tapelang-alphabet/benchmark.tape .
COPY tapelang-alphabet/python-3.12/run.py .

CMD ["./time.sh","python","run.py","benchmark.tape"]
