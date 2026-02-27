FROM golang:1.22
RUN apt-get update && apt-get install -y time

WORKDIR /app
COPY time.sh .
COPY matrixmultiply/go-1.22/app.go .
COPY matrixmultiply/go-1.22/go.mod .

RUN go build -o app app.go

CMD ["./time.sh","./app","1000"]
