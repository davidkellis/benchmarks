FROM julia:1.10
RUN apt-get update && apt-get install -y time

WORKDIR /app
COPY time.sh .
COPY json/sample.json .
COPY json/julia-1.10/run.jl .

RUN julia -e 'using Pkg; Pkg.add("JSON")'

CMD ["./time.sh","julia","run.jl"]
