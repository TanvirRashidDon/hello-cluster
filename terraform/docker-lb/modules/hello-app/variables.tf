## module inputs
variable "external_port" {
  type        = number
  description = "The HTTP port the web server will listen to"
}

variable "replicas" {
  type        = number
  description = "Number of app server instance"
}

## network 
variable "network_name" {
  default = "tf-hello-network"
}

## app server
variable "app_image" {
  default = "tanvirrashiddon/hello-server:latest"
}

variable "app_server_name" {
  default = "hello-server"
}

variable "app_port" {
  default = 80
}

## lb server
variable "nginx_config_tmp_file_name" {
  default = "/tmp/nginx-config.conf"
}

variable "lb" {
  default = "nginx:1.27.3"
}

variable "lb_listining_port" {
  default = 80
}
