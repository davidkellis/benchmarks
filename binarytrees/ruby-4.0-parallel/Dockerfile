FROM ruby:4.0
RUN apt-get update && apt-get install -y time

WORKDIR /app
COPY time.sh .
COPY binarytrees/ruby-4.0-parallel/run.rb .

CMD ["./time.sh","ruby","run.rb","21"]
