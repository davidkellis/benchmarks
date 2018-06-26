FROM debian:9.4

RUN apt-get update && apt-get install -y time curl unzip zip

# install compiler and runtime via sdkman; add new binaries to PATH
ENV SDKMAN_DIR /usr/local/sdkman
RUN curl -s "https://get.sdkman.io" | bash
RUN /bin/bash -c "source /usr/local/sdkman/bin/sdkman-init.sh && sdk install kotlin 1.2.50 && sdk install java 9.0.4-openjdk"
ENV PATH /usr/local/sdkman/candidates/kotlin/current/bin:/usr/local/sdkman/candidates/java/9.0.4-openjdk/bin:$PATH

WORKDIR /app

# keep in mind that the docker build command is being run from the benchmarks/ project's root directory
# and the context directory is being specified as the benchmarks/ root directory
COPY time.sh .
COPY matrixmultiply/kotlin1.2.50/*.kt .

RUN kotlinc matmul.kt -include-runtime -d run.jar

CMD ["./time.sh", "java", "-jar", "run.jar", "1000"]