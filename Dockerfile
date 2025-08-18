# syntax=docker/dockerfile:1.4

FROM golang:1.25 AS builder
WORKDIR /workspace/runtime-operator

# dependencies cache
COPY go.mod go.sum ./
RUN go mod download

# source code
COPY . .
RUN CGO_ENABLED=0 go build -o /go/bin/runtime-operator ./cmd

FROM cgr.dev/chainguard/static:latest AS release
COPY --from=builder /go/bin/runtime-operator /usr/local/bin/runtime-operator
ENTRYPOINT ["/usr/local/bin/runtime-operator"]
