# outputs.tf
output "cluster_name" {
  description = "Name of the created Kind cluster"
  value       = var.cluster_name
}

output "kubectl_context" {
  description = "The kubectl context for the created Kind cluster"
  value       = "kind-${var.cluster_name}"
}
