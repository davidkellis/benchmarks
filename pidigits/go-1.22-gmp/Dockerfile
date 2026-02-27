FROM golang:1.22
RUN apt-get update && apt-get install -y time libgmp-dev

WORKDIR /app
COPY time.sh .
COPY pidigits/go-1.22-gmp/app.go .
COPY pidigits/go-1.22-gmp/go.mod .
COPY pidigits/go-1.22-gmp/go.sum .

RUN go build -o app .

CMD ["./time.sh","./app","10000"]
