resource "kubernetes_ingress_v1" "nginx" {
  count = var.create_cluster ? 1 : 0

  metadata {
    name      = "nginx-${var.tenant_name}-ingress"
    namespace = "default"
    annotations = {
      "nginx.ingress.kubernetes.io/rewrite-target" = "/"
    }
  }

  spec {
    rule {
      http {
        path {
          path     = "/${var.tenant_name}"
          path_type = "Prefix"

          backend {
            service {
              name = "nginx-${var.tenant_name}"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}
