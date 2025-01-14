# syntax=docker/dockerfile:1

ARG GOLANG_VERSION="1.23.4"
ARG ALPINE_VERSION="3.20"
ARG DEBIAN_VERSION="12.8"

# Builder image
FROM golang:${GOLANG_VERSION}-alpine${ALPINE_VERSION} AS builder

WORKDIR /app

# Download dependencies
COPY go.mod ./
RUN go mod download

# Build the binary
COPY src/ ./src/
RUN go build -o hello-server ./src

# App image
FROM debian:${DEBIAN_VERSION}

WORKDIR /root/

COPY --from=builder /app/hello-server .

EXPOSE 8090

CMD ["./hello-server"]
