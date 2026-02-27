FROM eclipse-temurin:21
RUN apt-get update && apt-get install -y time

WORKDIR /app
COPY time.sh .
COPY fib/java-21/run.java .

RUN javac run.java

CMD ["./time.sh","java","run"]
