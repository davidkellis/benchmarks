FROM eclipse-temurin:25
RUN apt-get update && apt-get install -y time

WORKDIR /app
COPY time.sh .
COPY matrixmultiply/java-25/run.java .

RUN javac run.java

CMD ["./time.sh","java","run","1000"]
