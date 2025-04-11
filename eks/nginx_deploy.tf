resource "kubernetes_deployment" "nginx" {
  count = var.create_cluster ? 1 : 0

  metadata {
    name      = "nginx-${var.tenant_name}"
    namespace = "default"
    labels = {
      app = "nginx-${var.tenant_name}"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "nginx-${var.tenant_name}"
      }
    }

    template {
      metadata {
        labels = {
          app = "nginx-${var.tenant_name}"
        }
      }

      spec {
        container {
          name  = "nginx"
          image = "nginx:latest"

          port {
            container_port = 80
          }
        }
      }
    }
  }
}
