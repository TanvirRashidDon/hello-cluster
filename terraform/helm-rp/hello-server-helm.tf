provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

resource "helm_release" "hello-app" {
  name  = "sample"
  chart = "../../helm/ingress-rp/"
}

output "url" {
  value = "https://localhost/api"
}