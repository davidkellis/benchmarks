FROM eclipse-temurin:25
RUN apt-get update && apt-get install -y time curl unzip
RUN curl -sL https://github.com/JetBrains/kotlin/releases/download/v2.3.0/kotlin-compiler-2.3.0.zip -o kotlin.zip && \
    unzip kotlin.zip -d /opt && \
    rm kotlin.zip
ENV PATH="/opt/kotlinc/bin:${PATH}"

WORKDIR /app
COPY time.sh .
COPY fib/kotlin-2.3/run.kt .

RUN kotlinc run.kt -include-runtime -d run.jar

CMD ["./time.sh","java","-jar","run.jar"]
