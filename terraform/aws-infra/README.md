<a id="aws-readme"></a>
# What to expect?
Deploy a internet accessable web service in aws.

## Technical description
* Create a VPC
* Create Subnet for networking
* Create Gateway to connect VPC with internet
* Create an EC2 instance inside the network
* Allow internet to access the service
* Secure infra in 3 layers, VPC with Route, Subnet with Network ACL, Instance with Security groups

### Prerequisites:
1. Terraform installed
2. aws cli installed and configured with credentials

## Stage

```
cd ./terraform/aws-infra
terraform init
terraform workspace new stage
terraform workspace select stage
terraform apply -var-file env/stage.tfvars
```

## Prod

```
cd ./terraform/aws-infra
terraform init
terraform workspace new prod
terraform workspace select prod
terraform apply -var-file env/prod.tfvars
```