FROM ruby:2.5.1

RUN apt-get update && apt-get install time

WORKDIR /app

# keep in mind that the docker build command is being run from the benchmarks/ project's root directory
# and the context directory is being specified as the benchmarks/ root directory
COPY time.sh .
COPY sudoku/sudoku.txt .
COPY sudoku/python3.6.5/run.py .

CMD ./time.sh python run.py