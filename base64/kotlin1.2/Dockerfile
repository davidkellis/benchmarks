FROM zenika/kotlin:1.2

RUN apt-get update && apt-get install -y time

WORKDIR /app

# keep in mind that the docker build command is being run from the benchmarks/ project's root directory
# and the context directory is being specified as the benchmarks/ root directory
COPY time.sh .
COPY base64/kotlin1.2/*.kt .

RUN kotlinc base64.kt -include-runtime -d run.jar

CMD ["./time.sh", "kotlin", "-J-Xmx3G", "-cp", "run.jar", "Base64Kt"]