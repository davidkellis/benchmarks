FROM golang:1.26
RUN apt-get update && apt-get install -y time

WORKDIR /app
COPY time.sh .
COPY pidigits/go-1.26/app.go .

RUN go build -o app app.go

CMD ["./time.sh","./app","10000"]
