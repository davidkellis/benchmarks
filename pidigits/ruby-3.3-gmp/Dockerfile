FROM ruby:3.3
RUN apt-get update && apt-get install -y time libgmp-dev

WORKDIR /app
COPY time.sh .
COPY pidigits/ruby-3.3-gmp/run.rb .

RUN gem install gmp

CMD ["./time.sh","ruby","run.rb","10000"]
