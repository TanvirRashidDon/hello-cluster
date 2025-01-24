# API only
## Local RUN
`go run ./src/server.go`

### TEST
`curl http://localhost:8090/api`


## Docker RUN
`docker build -t hello-server .``
`docker run -d -p 8090:8090 hello-server`


# Load Balancing
## Buiild application image
`docker build -t hello-server .`

## Run to instance of the application
`docker run -d -p 8090:8090 hello-server`
`docker run -d -p 8090:8091 hello-server`

## Build nginx image for load balancing
`docker build -f Nginx.Dockerfile -t hello-nginx .`

## Run the load balancer
`docker run -d -p 8085:80 hello-nginx`

## Test the load balancer
`curl http://192.168.1.179:8085/hello/api`
