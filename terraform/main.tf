terraform {
  required_version = ">= 1.5.0"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.30"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

variable "namespace" {
  description = "Target Kubernetes namespace"
  type        = string
  default     = "platform"
}

resource "kubernetes_namespace" "platform" {
  metadata {
    name = var.namespace

    labels = {
      environment = "lab"
      managed-by  = "terraform"
    }
  }
}

resource "kubernetes_resource_quota" "platform" {
  metadata {
    name      = "platform-quota"
    namespace = kubernetes_namespace.platform.metadata[0].name
  }

  spec {
    hard = {
      "requests.cpu"    = "2"
      "requests.memory" = "2Gi"
      "limits.cpu"      = "4"
      "limits.memory"   = "4Gi"
      "pods"            = "10"
    }
  }
}

output "namespace" {
  value = kubernetes_namespace.platform.metadata[0].name
}

output "resource_quota" {
  value = kubernetes_resource_quota.platform.metadata[0].name
}
