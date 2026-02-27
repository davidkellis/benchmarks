FROM thevlang/vlang:latest
RUN apk update && apk add bash
RUN apk add time --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing

WORKDIR /app
COPY time.sh .
COPY fib/vlang/run.v .

RUN v run.v

CMD ["./time.sh","./run"]
