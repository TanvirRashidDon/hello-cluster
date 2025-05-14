variable "region" {
  default = "us-east-1"
}

#- vpc
variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}

variable "ingress_cidr_block" {
  default = "0.0.0.0/0"
}

#- subnet
variable "availability_zone" {
  default = "us-east-1a"
}

variable "public_subnet_cidr_block" {
  default = "10.0.1.0/24"
}

#- firewall
variable "egress_cidr_block" {
  default = "0.0.0.0/0"
}

#- instance
variable "instance_type" {
  default = "t2.micro"
}
