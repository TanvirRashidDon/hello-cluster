# What to expect?
1. Test the server as a linux service
2. Balance load using nginx (docker container)
3. Balance load using traefik (docker compose)
4. Use kubernetis default load balancing (random)
5. Load balencing with nginx in kubernetis


## 1. Test the server as a linux service
#### Prerequisites:
1. Go installed
2. Docker installed

### Local RUN
`sudo go run ./src/server.go`

#### TEST
`curl http://localhost/api`


### Docker RUN
```
docker build -t hello-server .
docker run -d -p 80:80 hello-server
```


## 2. Balance load using nginx
#### Prerequisites:
1. Docker installed
2. Dockewr compose installed

### First thing first. Create a network. Cause docker bridge network has no DNS
`docker network create -d bridge hello-network`

### Run to instance of the application
```
docker run --name hello-server-1 --network hello-network -d hello-server
// test server-1
// docker run --rm --network hello-network curlimages/curl curl http://hello-server-1/api
docker run --name hello-server-2 --network hello-network -d hello-server
// test server-2
// docker run --rm --network hello-network curlimages/curl curl http://hello-server-2/api
```


### Build nginx image for load balancing
`docker build -f Nginx.Dockerfile -t hello-nginx .`

### Run the load balancer
`docker run --name hello-nginx --network hello-network -d -p 80:80 hello-nginx`

### Test the load balancer
`curl http://localhost/api`


### using single compose file
```
docker compose up -d
// scale the server
docker compose up -d --scale hllo-server=3
docker compose down
```


## 3. Balance load using traefik
#### Prerequisites:
1. Docker installed 
2. Docker compose installed

```
docker compose -f traefik-compose.yml up -d
docker compose -f traefik-compose.yml up -d --scale hello-server=3
docker compose -f traefik-compose.yml down
```

## 4. Use kubernetis default load balancing (random)
#### Prerequists:
1. Docker installed
2. Kubernetis cluster installed (minikube, microk8s)
3. kubectl installed

#### Make image available for kuberneties
```
docker build -t hello-server:0.7 .
docker tag hello-server:0.7 localhost:5000/hello-server:latest

docker run -d -p 5000:5000 --name=registry registry:2
docker push localhost:5000/hello-server:latest
```

### create kuberneties objects
```
kubectl apply -f k8s-specifications/default-load-balancing/hello-server-deploy.yml
kubectl get deployments

kubectl apply -f k8s-specifications/default-load-balancing/hello-server-service.yml
kubectl get services
```

### Test
`curl http://localhost:30080/api`


## 5. Load balencing with nginx in kubernetis
#### Prerequists:
1. Docker installed
2. Kubernetis cluster installed (minikube, microk8s)
3. kubectl installed

#### Make image available for kuberneties
```
docker build -t hello-server:0.7 .
docker tag hello-server:0.7 localhost:5000/hello-server:l>

docker run -d -p 5000:5000 --name=registry registry:2
docker push localhost:5000/hello-server:latest
```

### create kuberneties objects
```
// make nginx config file accessable from the pod
kubectl create configmap nginx-config --from-file=./nginx/nginx-k8s.conf

kubectl apply -f k8s-specifications/nginx/hello-server-deploy.yml
kubectl apply -f k8s-specifications/nginx/hello-server-service.yml
kubectl apply -f k8s-specifications/nginx/nginx-deploy.yml
kubectl apply -f k8s-specifications/nginx/nginx-service.yml

```

### Test
`curl http://localhost:30080/api`

