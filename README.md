Docker image of this project can be found [here](https://hub.docker.com/r/tanvirrashiddon/hello-server). The image actively maintained by github action of this project.

# What to expect?
- [1. Test the server as a linux service](#1-test-the-server-as-a-linux-service)
- [2. Balance load using nginx (docker container)](#2-balance-load-using-nginx)
- [3. Balance load using traefik (docker compose)](#3-balance-load-using-traefik-docker-compose)
- [4. Use kubernetis default load balancing (random)](#4-use-kubernetis-default-load-balancing-random)
- [5. Reverse proxy with nginx in kubernetis (kubectl)](#5-reverse-proxy-with-nginx-in-kubernetis)
- [6. Helm chart for ingress with reverse proxy](#6-helm-chart-for-ingress-with-reverse-proxy)
- [7. Terraform deploy for aws, docker, helm](#7-terraform-deploy-for-aws-docker-helm)

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


## 7. Terraform deploy for aws, docker, helm
Indevidual Readme can be found here
* [Deploy as docker container](./terraform/docker-lb/README.md#docker-lb-readme)
* [AWS deployment](./terraform/aws-infra/README.md#aws-readme)

### Prerequisites:
1. Terraform installed
2. aws cli installed and configured with credentials for aws specific resources

General steps:
```
cd ./terraform/<the-feature-you-want-to-tese>
terrafrom init
terraform workspace new stage
terraform workspace select stage
terraform apply -var-file env/stage.tfvars
```

## Test
Terraform will print out the public url and testing command
```
curl <terraform-provisioned-url>/api
```
