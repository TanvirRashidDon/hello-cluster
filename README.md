Docker image of this project can be found [here](https://hub.docker.com/r/tanvirrashiddon/hello-server). The image actively maintained by github action of this project.

# What to expect?
1. Test the server as a linux service
2. Balance load using nginx (docker container)
3. Balance load using traefik (docker compose)
4. Use kubernetis default load balancing (random)
5. Reverse proxy with nginx in kubernetis
6. Helm chart for ingress with reverse proxy
7. Deploy as docker container using terraform

TODO:
* Add frontend
* Add DB
* Add Istio service mesh

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
2. Docker compose installed

### First thing first. Create a network. Cause docker bridge network has no DNS
`docker network create -d bridge hello-network`

### Run to instance of the application
```
docker run --name hello-server-1 --network hello-network -d tanvirrashiddon/hello-server
// test server-1
// docker run --rm --network hello-network curlimages/curl curl http://hello-server-1/api
docker run --name hello-server-2 --network hello-network -d tanvirrashiddon/hello-server
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

## IMPORTNT. To continue from here, we need instlalation of
1. Docker installed
2. Kubernetis cluster installed (minikube, microk8s)
3. kubectl installed


## 4. Use kubernetis default load balancing (random)
### create kuberneties objects
```
kubectl apply -f k8s-spec/default-lb/
kubectl delete -f k8s-spec/default-lb/
```

### Test
`curl http://localhost:30080/api`


## 5. Reverse proxy with nginx in kubernetis
### create kuberneties objects
```
// generate self signed rsa key and certificate for TLS
make keys KEY=/tmp/nginx.key CERT=/tmp/nginx.crt
// make certificate accessable from pod
kubectl create secret tls nginx-secret --key /tmp/nginx.key --cert /tmp/nginx.crt

// make nginx config file accessable from the pod
kubectl create configmap nginx-config --from-file=./nginx/nginx-k8s.conf

kubectl apply -f k8s-spec/nginx-rp/
```

### Test
```
curl -k https://localhost:30443/api
curl http://localhost:30080/api
```


## 6. Helm chart for ingress with reverse proxy
### Prerequisites:
1. Helm installed
2. Enaable ingress
`microk8s enable ingress`
3. Add TLS secret if not exist already
```
// generate self signed rsa key and certificate for TLS
make keys KEY=/tmp/tls.key CERT=/tmp/tls.crt
kubectl create secret tls ingress-tls-secret --cert=/tmp/tls.crt --key=/tmp/tls.key
```

```
helm install sample ./helm/ingress-rp
helm upgrade --set app.deploy.replicas=3 sample ./helm/ingress-rp/
helm rollback sample 1
helm unstall sample
```

### Test
```
curl -k https://localhost/api
```


## 7. Deploy as docker container using terraform
### Prerequisites:
1. Terraform installed

```
cd ./terraform/docker-lb/project-hello-app
terraform workspace new local
terraform apply
```
