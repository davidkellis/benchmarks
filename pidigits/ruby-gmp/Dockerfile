FROM ruby:latest

RUN apt-get update && apt-get install -y time libgmp-dev

WORKDIR /app

# keep in mind that the docker build command is being run from the benchmarks/ project's root directory
# and the context directory is being specified as the benchmarks/ root directory
COPY time.sh .
COPY pidigits/ruby-gmp/run.rb .

RUN gem install gmp

CMD ["./time.sh", "ruby", "run.rb", "10000"]
