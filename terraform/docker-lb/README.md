<a id="docker-lb-readme"></a>
# What to expect?
Deploy an docker web server behind the ngnix load balancer.

TODO:
* take environmet from commandline.

### Prerequisites:
1. Terraform installed

```
cd ./terraform/docker-lb
terraform init
terraform workspace new stage
terraform apply -var-file env/stage.tfvars
```

### Test
Terraform will printout the working url 
```
# example: curl http://localhost:8080/api
curl <url-from-output>/api
```