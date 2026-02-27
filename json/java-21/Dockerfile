FROM eclipse-temurin:21
RUN apt-get update && apt-get install -y time curl

RUN curl -o jackson-core.jar https://repo1.maven.org/maven2/com/fasterxml/jackson/core/jackson-core/2.9.6/jackson-core-2.9.6.jar
RUN curl -o jackson-databind.jar https://repo1.maven.org/maven2/com/fasterxml/jackson/core/jackson-databind/2.9.6/jackson-databind-2.9.6.jar
RUN curl -o jackson-annotations.jar https://repo1.maven.org/maven2/com/fasterxml/jackson/core/jackson-annotations/2.9.6/jackson-annotations-2.9.6.jar

WORKDIR /app
COPY time.sh .
COPY json/sample.json .
COPY json/java-21/run.java .
COPY json/java-21/Model.java .
COPY json/java-21/Root.java .

RUN javac -cp jackson-core.jar:jackson-databind.jar:jackson-annotations.jar:. run.java

CMD ["./time.sh","java","-cp","jackson-core.jar:jackson-databind.jar:jackson-annotations.jar:.","run"]
