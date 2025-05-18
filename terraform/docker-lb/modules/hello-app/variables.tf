## module inputs
variable "external_port" {
  type        = number
  description = "The HTTP port the web server will listen to"
}

variable "replicas" {
  type        = number
  description = "Number of app server instance"
}