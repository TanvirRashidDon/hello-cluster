# syntax=docker/dockerfile:1

# builder image
FROM golang:1.23.4-alpine3.20 as builder

WORKDIR /src

COPY /src .

RUN go mod download \
	&& go build -o hello-server


# output image
FROM scratch

COPY --from=builder /src/hello-server ./output

ENTRYPOINT ["./hello-server"]


