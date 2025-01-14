## Local RUN
`go run ./src/server.go`

### TEST
`curl http://localhost:8090/api`


## Docker RUN
`docker build -t hello-server:0.5 .``
`docker run -d -p 8090:8090 hello-server:0.5`

