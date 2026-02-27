FROM ruby:4.0
RUN apt-get update && apt-get install -y time

WORKDIR /app
COPY time.sh .
COPY pidigits/ruby-4.0/run.rb .

CMD ["./time.sh","ruby","run.rb","10000"]
