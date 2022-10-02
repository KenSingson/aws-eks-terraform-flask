resource "kubernetes_service_v1" "postgresql_service" {
  metadata {
    name = "postgresql"
  }
  spec {
    type = "ExternalName"
    external_name = "database-1.ckjbbprvryyb.ap-southeast-1.rds.amazonaws.com"
  }
}