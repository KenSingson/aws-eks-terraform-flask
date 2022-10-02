resource "kubernetes_deployment_v1" "myapp1" {
  metadata {
    name = "flaskapp-aws-microservice"
    labels = {
      app = "flaskapp-aws-restapp"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        app = "flaskapp-aws-restapp"
      }
    }

    template {
      metadata {
        name = "flaskapp-aws-restapp-pod"
        labels = {
          app = "flaskapp-aws-restapp"
        }
      }

      spec {
        container {
          image = "kensingson/flaskapp-aws:1.0.0"
          name  = "flaskapp-aws-restapp"
          port {
            container_port = 5000
          }
          env {
            name = "DB_HOSTNAME"
            value = "postgresql"
          }
          env {
            name = "DB_PORT"
            value = "5432"
          }
          env {
            name = "DB_NAME"
            value = "products"
          }
          env {
            name = "DB_USERNAME"
            value = "postgres"
          }
          env {
            name = "DB_PASSWORD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret_v1.products_secret.metadata.0.name
                key = "db-password"
              }
            }
          }
        }
      }
    }
  }
}