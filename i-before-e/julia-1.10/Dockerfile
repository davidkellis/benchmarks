FROM julia:1.10
RUN apt-get update && apt-get install -y time

WORKDIR /app
COPY time.sh .
COPY i-before-e/wordlist.txt .
COPY i-before-e/julia-1.10/run.jl .

CMD ["./time.sh","julia","run.jl","wordlist.txt"]
