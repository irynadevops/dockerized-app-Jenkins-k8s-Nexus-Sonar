resource "kubernetes_namespace" "jenkins" {
  metadata {
    annotations = {
      name = "namespace"
    }
    labels = {
      purpose = "jenkins"
    }
    name = "jenkins"
  }
}

resource "kubernetes_persistent_volume_claim" "jenkins" {
  metadata {
    name      = "jenkins-pvc-claim"
    namespace = kubernetes_namespace.jenkins.metadata.0.name
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "100Gi"
      }
    }
  }
}

resource "kubernetes_deployment" "jenkins" {
  metadata {
    name      = "jenkins"
    namespace = kubernetes_namespace.jenkins.metadata.0.name
    labels = {
      app     = "jenkins"
      apptype = "master"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app     = "jenkins"
        apptype = "master"
      }
    }
    template {
      metadata {
        labels = {
          app     = "jenkins"
          apptype = "master"
        }
      }
      spec {
        security_context {
          fs_group = 1000
        }
        container {
          image = "jenkins/jenkins:lts"
          name  = "jenkins"
          port {
            container_port = 8080
          }
          port {
            container_port = 50000
          }
          env {
            name  = "JAVA_OPTS"
            value = "-Djenkins.install.runSetupWizard=false"
          }
          resources{
            limits{
              cpu: "1"
            requests:
              cpu: "0.5"
            }
          args:
          - -cpus
          - "2"
          }
          volume_mount {
            mount_path = "/var/jenkins_home"
            name       = "jenkins-home"
          }
        }
        volume {
          name = "jenkins-home"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.jenkins.metadata.0.name
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "jenkins" {
  metadata {
    name      = "jenkins-service"
    namespace = kubernetes_namespace.jenkins.metadata.0.name
  }
  spec {
    selector = {
      app     = kubernetes_deployment.jenkins.spec.0.template.0.metadata[0].labels.app
      apptype = kubernetes_deployment.jenkins.spec.0.template.0.metadata[0].labels.apptype
    }
    port {
      port        = 80
      target_port = 8080
    }
    port {
      port        = 50000
      target_port = 50000
    }
    type = "LoadBalancer"
  }
}

resource "kubernetes_ingress" "jenkins" {
  metadata {
    name      = "jenkins-ingress"
    namespace = kubernetes_namespace.jenkins.metadata.0.name
    annotations = {
      "kubernetes.io/ingress.class"                = "nginx"
      "nginx.ingress.kubernetes.io/rewrite-target" = "/"
    }
  }
  spec {
    rule {
      host = var.ingress_host
      http {
        path {
          backend {
            service_name = kubernetes_service.jenkins.metadata.0.name
            service_port = 80
          }
          path = "/"
        }
      }
    }
  }
}
