FROM zenika/kotlin:latest

RUN yum -y install time curl

WORKDIR /app

# keep in mind that the docker build command is being run from the benchmarks/ project's root directory
# and the context directory is being specified as the benchmarks/ root directory
COPY time.sh .
COPY binarytrees/kotlin/*.kt .

RUN kotlinc binarytrees.kt -include-runtime -d run.jar

CMD ["./time.sh", "kotlin", "-cp", "run.jar", "binarytrees", "21"]
