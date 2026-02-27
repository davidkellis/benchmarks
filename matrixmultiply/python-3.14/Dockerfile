FROM python:3.14
RUN apt-get update && apt-get install -y time

WORKDIR /app
COPY time.sh .
COPY matrixmultiply/python-3.14/run.py .

CMD ["./time.sh","python","run.py","1000"]
