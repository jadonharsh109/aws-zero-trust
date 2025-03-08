#!/bin/bash

set -e

readonly_role="${readonly_role_arn}"
fullaccess_role="${fullaccess_role_arn}"

error_exit() {
    echo "$1" 1>&2
    exit 1
}

echo "Fetching existing aws-auth ConfigMap..."
kubectl get configmap aws-auth -n kube-system -o yaml > /tmp/aws-auth-configmap.yaml || error_exit "Error: Failed to fetch aws-auth ConfigMap."

echo "Backing up the original aws-auth ConfigMap..."
cp /tmp/aws-auth-configmap.yaml /tmp/aws-auth-configmap-backup.yaml || error_exit "Error: Failed to backup the original ConfigMap."

new_roles=$(cat <<EOT
    - rolearn: $readonly_role
      username: readonly
      groups:
        - readonly-group
    - rolearn: $fullaccess_role
      username: fullaccess
      groups:
        - fullaccess-group
EOT
)

echo "Appending new roles to the aws-auth ConfigMap..."
sed -i.bak '/mapRoles:/r /dev/stdin' /tmp/aws-auth-configmap.yaml <<< "$new_roles" || error_exit "Error: Failed to append new roles to the ConfigMap."

echo "Applying the updated aws-auth ConfigMap..."
kubectl apply -f /tmp/aws-auth-configmap.yaml || error_exit "Error: Failed to apply the updated aws-auth ConfigMap."

echo "Cleaning up temporary files..."
rm -f /tmp/aws-auth-configmap.yaml /tmp/aws-auth-configmap-backup.yaml /tmp/aws-auth-configmap.yaml.bak || error_exit "Warning: Failed to clean up temporary files."

echo "Updated aws-auth ConfigMap applied successfully!"