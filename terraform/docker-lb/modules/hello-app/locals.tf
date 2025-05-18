locals {
  network_name = "tf-hello-network"
  app_image = "tanvirrashiddon/hello-server:latest"
  app_server_name = "hello-server"
  app_port = 80
  nginx_config_tmp_file_name = "/tmp/nginx-config.conf"
  lb = "nginx:1.27.3"
  lb_listining_port = 80

  hello_server_names = [for i in range(1, var.replicas + 1) :
    "${local.app_server_name}-${i}"
  ]
}