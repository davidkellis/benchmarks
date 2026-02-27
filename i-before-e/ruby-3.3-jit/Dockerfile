FROM ruby:3.3
RUN apt-get update && apt-get install -y time

WORKDIR /app
COPY time.sh .
COPY i-before-e/wordlist.txt .
COPY i-before-e/ruby-3.3-jit/run.rb .

CMD ["./time.sh","ruby","--jit","run.rb","wordlist.txt"]
