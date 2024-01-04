FROM ruby:latest

RUN apt-get update && apt-get install -y time

WORKDIR /app

# keep in mind that the docker build command is being run from the benchmarks/ project's root directory
# and the context directory is being specified as the benchmarks/ root directory
COPY time.sh .
COPY binarytrees/ruby/run.rb .

CMD ["./time.sh", "ruby", "run.rb", "21"]
