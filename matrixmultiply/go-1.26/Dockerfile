FROM golang:1.26
RUN apt-get update && apt-get install -y time

WORKDIR /app
COPY time.sh .
COPY matrixmultiply/go-1.26/app.go .
COPY matrixmultiply/go-1.26/go.mod .

RUN go build -o app app.go

CMD ["./time.sh","./app","1000"]
