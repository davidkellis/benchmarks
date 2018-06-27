FROM java:openjdk-9-b149-jdk

RUN apt-get update && apt-get install -y time curl

WORKDIR /app

RUN curl -o dsl-json.jar http://repo1.maven.org/maven2/com/dslplatform/dsl-json/1.7.4/dsl-json-1.7.4.jar

# keep in mind that the docker build command is being run from the benchmarks/ project's root directory
# and the context directory is being specified as the benchmarks/ root directory
COPY time.sh .
COPY json/sample.json .
COPY json/java-openjdk-9-b149-jdk/*.java .

RUN javac -cp dsl-json.jar json.java

CMD ["./time.sh", "java", "json"]