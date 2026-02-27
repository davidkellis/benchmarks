FROM python:3.12
RUN apt-get update && apt-get install -y time

WORKDIR /app
COPY time.sh .
COPY i-before-e/wordlist.txt .
COPY i-before-e/python-3.12/run.py .

CMD ["./time.sh","python","run.py","wordlist.txt"]
