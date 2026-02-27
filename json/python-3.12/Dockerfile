FROM python:3.12
RUN apt-get update && apt-get install -y time

WORKDIR /app
COPY time.sh .
COPY json/sample.json .
COPY json/python-3.12/run.py .

CMD ["./time.sh","python","run.py"]
