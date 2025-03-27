variable "external_ports" {
  type = map(any)
  default = {
    "local"  = 8080
    "remote" = 80
  }
}

variable "app_server_replica_count" {
  type = map(any)
  default = {
    "local"  = 3
    "remote" = 4
  }
}
