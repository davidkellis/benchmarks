FROM amazoncorretto:21

RUN yum -y install time curl

WORKDIR /app

# keep in mind that the docker build command is being run from the benchmarks/ project's root directory
# and the context directory is being specified as the benchmarks/ root directory
COPY time.sh .
COPY sudoku/sudoku.txt .
COPY sudoku/java/*.java .

RUN ["javac", "sudoku_v1.java"]

CMD ["./time.sh", "java", "sudoku_v1"]
