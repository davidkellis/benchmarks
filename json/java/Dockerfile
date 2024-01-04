FROM amazoncorretto:21

RUN yum -y install time curl

WORKDIR /app

RUN curl -o jackson-core.jar https://repo1.maven.org/maven2/com/fasterxml/jackson/core/jackson-core/2.9.6/jackson-core-2.9.6.jar
RUN curl -o jackson-databind.jar https://repo1.maven.org/maven2/com/fasterxml/jackson/core/jackson-databind/2.9.6/jackson-databind-2.9.6.jar
RUN curl -o jackson-annotations.jar https://repo1.maven.org/maven2/com/fasterxml/jackson/core/jackson-annotations/2.9.6/jackson-annotations-2.9.6.jar

# keep in mind that the docker build command is being run from the benchmarks/ project's root directory
# and the context directory is being specified as the benchmarks/ root directory
COPY time.sh .
COPY json/sample.json .
COPY json/java/*.java ./

RUN javac -cp jackson-core.jar:jackson-databind.jar:jackson-annotations.jar:. json.java

CMD ./time.sh java -cp jackson-core.jar:jackson-databind.jar:jackson-annotations.jar:. json
