module "hello-app" {
  source        = "../modules/hello-app"
  external_port = lookup(var.external_ports, "local")
  replicas      = lookup(var.app_server_replica_count, "local")
}

output "url" {
  value = "http://localhost:${lookup(var.external_ports, "local")}"
}
