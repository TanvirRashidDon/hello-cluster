# What to expect?
1. Test the server as a linux service
2. Balance load using nginx
3. Balance load using traefik


## 1. Test the server as a linux service
### Local RUN
`sudo go run ./src/server.go`

#### TEST
`curl http://localhost/api`


### Docker RUN
`docker build -t hello-server .`
`docker run -d -p 80:80 hello-server`


## 2. Balance load using nginx

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


### using single compose file
`docker compose up -d`
// scale the server
`docker compose up -d --scale hllo-server=3`
`docker compose down`


## 3. Balance load using traefik
`docker compose -f traefik-compose.yml up -d`
`docker compose -f traefik-compose.yml up -d --scale hello-server=3`
`docker compose -f traefik-compose.yml down`
