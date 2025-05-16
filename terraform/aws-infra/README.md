# Prod

```
terraform init
terraform workspace new prod
terraform workspace select prod
terraform apply -var-file env/prod.tfvars
```

# Stage

```
terraform init
terraform workspace new stage
terraform workspace select stage
terraform apply -var-file env/stage.tfvars
```