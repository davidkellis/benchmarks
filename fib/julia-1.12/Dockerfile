FROM julia:1.12
RUN apt-get update && apt-get install -y time

WORKDIR /app
COPY time.sh .
COPY fib/julia-1.12/run.jl .

CMD ["./time.sh","julia","run.jl"]
