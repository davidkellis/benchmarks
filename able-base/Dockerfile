FROM golang:1.25

RUN apt-get update && apt-get install -y time && rm -rf /var/lib/apt/lists/*

COPY v12/interpreters/go/ /able/v12/interpreters/go/
COPY v12/parser/tree-sitter-able/ /able/v12/parser/tree-sitter-able/
COPY v12/stdlib/ /able/v12/stdlib/
COPY v12/kernel/ /able/v12/kernel/

RUN cd /able/v12/interpreters/go && \
    GOCACHE=/tmp/gocache go build -o /able/v12/bin/able ./cmd/able && \
    ln -s /able/v12/bin/able /usr/local/bin/able && \
    rm -rf /tmp/gocache

ENV ABLE_GO_MODULE_ROOT=/able/v12/interpreters/go

WORKDIR /app
