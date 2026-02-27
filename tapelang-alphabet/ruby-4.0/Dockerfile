FROM ruby:4.0
RUN apt-get update && apt-get install -y time

WORKDIR /app
COPY time.sh .
COPY tapelang-alphabet/benchmark.tape .
COPY tapelang-alphabet/ruby-4.0/run.rb .

CMD ["./time.sh","ruby","run.rb","benchmark.tape"]
