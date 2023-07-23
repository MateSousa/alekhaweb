provider "kubernetes" {
  config_path = "~/.kube/config"  # Path to your kubeconfig file
}

resource "kubernetes_namespace" "example" {
  metadata {
    name = "example"
  }
}


provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"  # Path to your kubeconfig file
  }
}

resource "helm_release" "argocd" {
    name       = "argocd"
    repository = "https://argoproj.github.io/argo-helm"
    chart      = "argo-cd"
    namespace  = kubernetes_namespace.example.metadata[0].name
    
    set {
        name = "server.extraArgs[0]"
        value = "--insecure"
    }
}

resource "helm_release" "crossplane" {
    name       = "crossplane"
    repository = "https://charts.crossplane.io/stable"
    chart      = "crossplane"
    namespace  = kubernetes_namespace.example.metadata[0].name
}

