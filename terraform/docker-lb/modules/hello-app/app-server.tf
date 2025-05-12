data "docker_registry_image" "app" {
  name = var.app_image
}

resource "docker_image" "hello_image" {
  name          = data.docker_registry_image.app.name
  pull_triggers = [data.docker_registry_image.app.sha256_digest]
}

locals {
  hello_server_names = [for i in range(1, var.replicas + 1) :
    "${var.app_server_name}-${i}"
  ]
}

resource "docker_container" "hello_server" {
  for_each = toset(local.hello_server_names)

  name    = each.key
  image   = docker_image.hello_image.image_id
  restart = "always"

  networks_advanced {
    name = docker_network.app_network.name
  }

# TODO: fix healthcheck. (don, 8-4-2025)
  # healthcheck {
  #   test     = ["CMD", "curl", "-f", "http://localhost:${var.app_port}/api"]
  #   interval = "10s"
  #   timeout  = "5s"
  #   retries  = 3
  # }
}
