FROM ruby:3.3
RUN apt-get update && apt-get install -y time

WORKDIR /app
COPY time.sh .
COPY sudoku/sudoku.txt .
COPY sudoku/ruby-3.3/run.rb .

CMD ["./time.sh","ruby","run.rb"]
