FROM amazoncorretto:21

RUN yum -y install time curl

WORKDIR /app

# keep in mind that the docker build command is being run from the benchmarks/ project's root directory
# and the context directory is being specified as the benchmarks/ root directory
COPY time.sh .
COPY matrixmultiply/java/*.java .

RUN javac matrixmultiply.java

CMD ["./time.sh", "java", "matrixmultiply", "1000"]
