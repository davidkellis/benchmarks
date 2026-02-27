FROM ruby:4.0
RUN apt-get update && apt-get install -y time

WORKDIR /app
COPY time.sh .
COPY i-before-e/wordlist.txt .
COPY i-before-e/ruby-4.0-jit/run.rb .

CMD ["./time.sh","ruby","--jit","run.rb","wordlist.txt"]
