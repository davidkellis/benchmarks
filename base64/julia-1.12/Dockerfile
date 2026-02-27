FROM julia:1.12
RUN apt-get update && apt-get install -y time

WORKDIR /app
COPY time.sh .
COPY base64/julia-1.12/run.jl .

RUN julia -e 'using Pkg; Pkg.add("Codecs")'
RUN julia -e 'using Pkg; Pkg.add("MD5")'

CMD ["./time.sh","julia","run.jl"]
