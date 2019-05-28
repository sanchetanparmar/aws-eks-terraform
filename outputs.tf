output "kubeconfig" {
  value = "${module.eks.kubeconfig}"
}

output "config-map" {
  value = "${module.eks.config-map-aws-auth}"
}

resource "local_file" "kubeconfig" {
  content  = "${module.eks.kubeconfig}"
  filename = "/home/user/.kube/config"
}

resource "local_file" "configmap" {
  content  = "${module.eks.config-map-aws-auth}"
  filename = "/tmp/configmap"
}
