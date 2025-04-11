
resource "kubernetes_deployment" "nginx" {
  count = 2

  metadata {
    name      = "nginx-${count.index}"
    namespace = "default"
    labels = {
      app = "nginx-${count.index}"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "nginx-${count.index}"
      }
    }
    template {
      metadata {
        labels = {
          app = "nginx-${count.index}"
        }
      }
      spec {
        container {
          name  = "nginx"
          image = "nginx:latest"
        }
      }
    }
  }
}
