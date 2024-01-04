FROM ruby:latest

RUN apt-get update && apt-get install time

WORKDIR /app

# keep in mind that the docker build command is being run from the benchmarks/ project's root directory
# and the context directory is being specified as the benchmarks/ root directory
COPY time.sh .
COPY pidigits/ruby/run.rb .

CMD ["./time.sh", "ruby", "run.rb", "10000"]
