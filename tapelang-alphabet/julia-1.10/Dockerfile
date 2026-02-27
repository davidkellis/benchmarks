FROM julia:1.10
RUN apt-get update && apt-get install -y time

WORKDIR /app
COPY time.sh .
COPY tapelang-alphabet/benchmark.tape .
COPY tapelang-alphabet/julia-1.10/run.jl .

CMD ["./time.sh","julia","run.jl","benchmark.tape"]
