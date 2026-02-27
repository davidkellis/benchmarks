FROM eclipse-temurin:25
RUN apt-get update && apt-get install -y time

WORKDIR /app
COPY time.sh .
COPY monte_carlo_pi/java-25/run.java .

RUN javac run.java

CMD ["./time.sh","java","run"]
