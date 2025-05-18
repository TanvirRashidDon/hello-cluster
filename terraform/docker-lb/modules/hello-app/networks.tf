resource "docker_network" "app_network" {
  name   = local.network_name
  driver = "bridge"
}