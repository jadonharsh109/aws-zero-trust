# Apply Kubernetes manifests after generating kubeconfig
resource "null_resource" "apply_manifests" {
  provisioner "local-exec" {
    command = "kubectl apply -f ../../../k8s/base/rbac/"
  }
}

# Update the AWS Auth ConfigMap to assign IAM roles to Kubernetes groups
resource "null_resource" "update_aws_auth" {
  provisioner "local-exec" {
    # Use the templatefile function to populate the update-aws-auth script
    command = templatefile("${path.module}/script/update-aws-auth.sh.tpl", {
      readonly_role_arn   = var.readonly_role_arn,
      fullaccess_role_arn = var.fullaccess_role_arn
    })
  }
}
