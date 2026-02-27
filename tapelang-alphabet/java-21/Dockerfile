FROM eclipse-temurin:21
RUN apt-get update && apt-get install -y time

WORKDIR /app
COPY time.sh .
COPY tapelang-alphabet/benchmark.tape .
COPY tapelang-alphabet/java-21/run.java .

RUN javac run.java

CMD ["./time.sh","java","run","benchmark.tape"]
