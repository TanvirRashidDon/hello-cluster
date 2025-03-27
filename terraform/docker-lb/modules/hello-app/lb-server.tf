## prepare nginx config file
locals {
  nginx_config_content = templatefile("../../../nginx/nginx-terraform.conf.tpl", {
    upstream_servers = local.hello_server_names
    upstream_port    = var.app_port
    nginx_port    = var.lb_listining_port
  })
}

resource "terraform_data" "nginx_config" {
  input = local.nginx_config_content
}

resource "local_file" "nginx_config_file" {
  content  = terraform_data.nginx_config.input
  filename = var.nginx_config_tmp_file_name
  lifecycle {
    replace_triggered_by = [terraform_data.nginx_config]
  }
}

## lb server
resource "docker_image" "lb_image" {
  name = var.lb
}

resource "docker_container" "lb_server" {
  depends_on = [docker_container.hello_server]

  name    = "load-balancer"
  image   = docker_image.lb_image.image_id
  restart = "always"
  ports {
    internal = var.lb_listining_port
    external = var.external_port
  }

  networks_advanced {
    name = docker_network.app_network.name
  }

  volumes {
    host_path      = local_file.nginx_config_file.filename
    container_path = "/etc/nginx/conf.d/default.conf"
    read_only      = true
  }
}
