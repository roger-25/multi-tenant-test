
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
      resources {
        limits = {
          cpu = "500m"
          memory = "512Mi"
        }
        requests = {
          cpu = "200m"
          memory = "256Mi"
        }
      }
          name  = "nginx"
          image = "nginx:latest"
        }
      }
    }
  }
}


resource "kubernetes_service" "nginx_service" {
  metadata {
    name      = "nginx-service"
    namespace = "default"
    labels = {
      app = "nginx"
    }
  }

  spec {
    selector = {
      app = "nginx"
    }

    port {
      port        = 80
      target_port = 80
    }

    type = "NodePort"
  }
}

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
resource "kubernetes_horizontal_pod_autoscaler_v2" "nginx_hpa" {
  metadata {
    name = "nginx-hpa"
    namespace = "default"
  }

  spec {
    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = kubernetes_deployment.nginx.metadata[0].name
    }

    min_replicas = 2
    max_replicas = 5

    metric {
      type = "Resource"
      resource {
        name = "cpu"
        target {
          type               = "Utilization"
          average_utilization = 60
        }
      }
    }
  }
}