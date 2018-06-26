FROM java:openjdk-9-b149-jdk

RUN apt-get update && apt-get install -y time

WORKDIR /app

# keep in mind that the docker build command is being run from the benchmarks/ project's root directory
# and the context directory is being specified as the benchmarks/ root directory
COPY time.sh .
COPY fib/java-openjdk-9-b149-jdk/*.java .

RUN javac fibonacci.java

CMD ["./time.sh", "java", "fibonacci"]