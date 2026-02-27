FROM python:3.14
RUN apt-get update && apt-get install -y time

WORKDIR /app
COPY time.sh .
COPY sudoku/sudoku.txt .
COPY sudoku/python-3.14/run.py .

CMD ["./time.sh","python","run.py"]
