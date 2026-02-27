FROM golang:1.22
RUN apt-get update && apt-get install -y time

WORKDIR /app
COPY time.sh .
COPY json/sample.json .
COPY json/go-1.22/app.go .

RUN go build -o app app.go

CMD ["./time.sh","./app"]
