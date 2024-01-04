FROM amazoncorretto:21

RUN yum -y install time curl

WORKDIR /app

# keep in mind that the docker build command is being run from the benchmarks/ project's root directory
# and the context directory is being specified as the benchmarks/ root directory
COPY time.sh .
COPY tapelang-alphabet/benchmark.tape .
COPY tapelang-alphabet/java/*.java ./

RUN javac tapelang.java

CMD ./time.sh java tapelang benchmark.tape
