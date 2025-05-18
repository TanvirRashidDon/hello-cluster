module "hello-app" {
  source        = "./modules/hello-app"
  external_port = var.external_port
  replicas      = var.app_server_replica_count
}

output "application_url" {
  value       = "http://localhost:${var.external_port}"
  description = "Application public url"
}

output "test" {
  value       = "curl http://localhost:${var.external_port}/api"
  description = "Command to test the app"
}