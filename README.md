# What to expect?
1. Test the server as a linux service
2. Test load balancing using nginx
3. Test with docker compose


## API only
### Local RUN
`sudo go run ./src/server.go`

#### TEST
`curl http://localhost/api`


### Docker RUN
`docker build -t hello-server .``
`docker run -d -p 80:80 hello-server`


## Load Balancing

### First thing first. Create a network. Cause docker bridge network has no DNS
`docker network create -d bridge hello-network`

### Run to instance of the application
`docker run --name hello-server-1 --network hello-network -d hello-server`
// test server-1
// `docker run --rm --network hello-network curlimages/curl curl http://hello-server-1/api`
`docker run --name hello-server-2 --network hello-network -d hello-server`
// test server-2
// `docker run --rm --network hello-network curlimages/curl curl http://hello-server-2/api`


### Build nginx image for load balancing
`docker build -f Nginx.Dockerfile -t hello-nginx .`

### Run the load balancer
`docker run --name hello-nginx --network hello-network -d -p 80:80 hello-nginx`

### Test the load balancer
`curl http://localhost/api`


# Docker compose
`docker compose up -d`
// scale the server
`docker compose up -d --scale hllo-server=3`
`docker compose down`
