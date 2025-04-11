resource "kubernetes_ingress_v1" "nginx_ingress" {
  metadata {
    name      = "nginx-ingress"
    namespace = "default"
    annotations = {
      "kubernetes.io/ingress.class" = "alb"
      "alb.ingress.kubernetes.io/scheme" = "internet-facing"
    }
  }

  spec {
    rule {
      http {
        path {
          path     = "/*"
          path_type = "ImplementationSpecific"

          backend {
            service {
              name = kubernetes_service.nginx_service.metadata[0].name
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