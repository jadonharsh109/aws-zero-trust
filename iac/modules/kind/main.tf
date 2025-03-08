resource "null_resource" "kind_cluster" {
  provisioner "local-exec" {
    command = <<-EOT
      # Create the Kind cluster with config
      kind create cluster --name ${var.cluster_name} --config ${path.module}/kind-config.yaml
                
      echo "Kind cluster ${var.cluster_name} has been successfully created!"
    EOT
  }

  provisioner "local-exec" {
    when    = destroy
    command = "kind delete cluster --name ${self.triggers.cluster_name}"
  }

  triggers = {
    cluster_name = var.cluster_name
  }
}
