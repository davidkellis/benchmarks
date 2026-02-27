FROM ruby:4.0
RUN apt-get update && apt-get install -y time

WORKDIR /app
COPY time.sh .
COPY matrixmultiply/ruby-4.0/run.rb .

CMD ["./time.sh","ruby","run.rb","1000"]
