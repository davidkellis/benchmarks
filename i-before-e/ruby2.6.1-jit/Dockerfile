FROM ruby:2.6.1

RUN apt-get update && apt-get install -y time

WORKDIR /app

# keep in mind that the docker build command is being run from the benchmarks/ project's root directory
# and the context directory is being specified as the benchmarks/ root directory
COPY time.sh .
COPY i-before-e/wordlist.txt .
COPY i-before-e/ruby2.6.1-jit/run.rb .

CMD ["./time.sh", "ruby", "--jit", "run.rb", "wordlist.txt"]