
resource "kubernetes_service_v1" "flaskapp_aws_nlb" {
  metadata {
    name = "flaskapp-aws-restapp-service-nlb"
    annotations = {
        "service.beta.kubernetes.io/aws-load-balancer-type" = "nlb"
    }
  }
  spec {
    selector = {
      app = kubernetes_deployment_v1.myapp1.spec.0.selector.0.match_labels.app
    }

    port {
      port        = 80
      target_port = 5000
    }

    type = "LoadBalancer"
  }
}