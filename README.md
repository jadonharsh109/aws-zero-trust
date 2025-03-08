# Kubernetes Security with Zero-Trust Architecture

![Zero-Trust Architecture](https://img.shields.io/badge/Architecture-Zero--Trust-blue)
![Kubernetes](https://img.shields.io/badge/Platform-Kubernetes-326CE5)
![Security](https://img.shields.io/badge/Focus-Security-red)
![License](https://img.shields.io/badge/License-MIT-green)

A comprehensive implementation of zero-trust security principles for Kubernetes environments, providing defense-in-depth protection for containerized applications.

## 🔒 Project Overview

This project demonstrates a production-ready approach to implementing zero-trust architecture in Kubernetes, following the principle of "never trust, always verify." It provides a complete security framework with infrastructure-as-code (IaC) for both local development and cloud deployments.

### Key Security Components

- **Role-Based Access Control (RBAC)**: Fine-grained access controls following least privilege principles
- **Policy Enforcement**: Using Kyverno for declarative policy management
- **Network Segmentation**: Strict network policies with Calico for microsegmentation
- **Container Security**: Image scanning and runtime protection
- **Mutual TLS**: Secure service-to-service communication
- **Security Monitoring**: Real-time threat detection

## 🏗️ Architecture

The project implements a layered security approach:

1. **Infrastructure Layer**: Secure VPC, IAM, and EKS configuration
2. **Cluster Layer**: Hardened Kubernetes with RBAC and policy enforcement
3. **Network Layer**: Segmentation with Calico network policies
4. **Workload Layer**: Secure application deployments with strict pod security contexts

## 📁 Repository Structure

```
.
├── iac                             # Infrastructure as Code
│   ├── environments                # Environment-specific configurations
│   │   ├── dev                     # Development environment
│   │   └── local                   # Local development environment
│   └── modules                     # Terraform modules
│       ├── eks                     # EKS cluster configuration
│       ├── eks-auth                # EKS authentication
│       ├── iam                     # IAM roles and policies
│       ├── kind                    # Local Kubernetes with KinD
│       └── vpc                     # Network infrastructure
└── k8s                             # Kubernetes manifests
    ├── app                         # Application manifests
    │   ├── auth.yaml               # Authentication service
    │   ├── checklist.yaml          # Checklist service
    │   ├── ingress                 # Ingress configurations
    │   ├── kafka.yaml              # Kafka deployment
    │   ├── kanbanboard.yaml        # Kanban board service
    │   ├── namespace               # Namespace definitions
    │   ├── notify.yaml             # Notification service
    │   └── pomodoro.yaml           # Pomodoro timer service
    ├── base                        # Base configurations
    │   └── rbac                    # RBAC policies
    ├── calico                      # Network policies
    │   ├── backend-kafka-network.yaml
    │   ├── database-backend-network.yaml
    │   └── kafka-zookeeper-network.yaml
    └── kyverno                     # Policy enforcement
        ├── allow-dns.yaml          # DNS access policy
        ├── restrict-all-traffic.yaml # Default deny policy
        ├── restrict-latest-tag.yaml  # Prevent 'latest' tag usage
        └── restrict-unknown-registry.yaml # Approved registry policy
```

## 🚀 Getting Started

### Prerequisites

- Terraform >= 1.0.0
- kubectl >= 1.22
- AWS CLI (for cloud deployment)
- Docker (for local development)
- kind (for local k8s cluster)
- Helm >= 3.0.0 (for Kyverno installation)

### Local Development Setup

```bash
# Clone the repository
git clone https://github.com/jadonharsh109/aws-zero-trust.git
cd aws-zero-trust

# Deploy local Kubernetes cluster with KinD
cd iac/environments/local
terraform init
terraform apply

# Install Calico for network policies
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.29.2/manifests/calico.yaml
kubectl apply -f https://docs.projectcalico.org/manifests/crds.yaml

# Install Kyverno for policy enforcement
helm repo add kyverno https://kyverno.github.io/kyverno/
helm repo update
helm install kyverno kyverno/kyverno -n kyverno --create-namespace

# Apply kyverno policies
kubectl apply -f k8s/kyverno/

# Deploy sample application with security policies
kubectl apply -f k8s/app/namespace/
kubectl apply -f k8s/app/

# Apply Calico policies
calicoctl apply -f k8s/calico/ --allow-version-mismatch
```

### Cloud Deployment

```bash
# Configure AWS credentials
aws configure

# Deploy EKS infrastructure
cd iac/environments/dev
terraform init
terraform apply

# Install Calico for network policies
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.29.2/manifests/calico.yaml
kubectl apply -f https://docs.projectcalico.org/manifests/crds.yaml

# Install Kyverno for policy enforcement
helm repo add kyverno https://kyverno.github.io/kyverno/
helm repo update
helm install kyverno kyverno/kyverno -n kyverno --create-namespace

# Apply kyverno policies
kubectl apply -f k8s/kyverno/

# Deploy sample application with security policies
kubectl apply -f k8s/app/namespace/
kubectl apply -f k8s/app/

# Apply Calico policies
calicoctl apply -f k8s/calico/ --allow-version-mismatch
```

## 🔐 Security Features

### RBAC Implementation

The project implements comprehensive RBAC with:

- Custom roles following the least privilege principle
- Namespace isolation for multi-tenancy
- Service accounts with limited permissions

### Policy Enforcement with Kyverno

Key policies include:

- Preventing privileged containers
- Enforcing resource limits
- Requiring approved image registries
- Prohibiting the use of the 'latest' tag
- Enforcing security contexts

### Network Segmentation with Calico

The project implements zero-trust networking with:

- Default-deny policies
- Microsegmentation between application components
- Explicit allowlists for necessary communication
- Secure egress controls

### Additional Security Controls

- **mTLS**: Secure service-to-service communication (To Do)
- **Image Scanning**: Pre-deployment vulnerability scanning (To Do)
- **Runtime Security**: Monitoring for suspicious activities (To Do)
- **Secret Management**: Secure handling of sensitive data (To Do)

## 🧪 Testing Security Controls

### Testing Network Policies

```bash
# Create a kafka-ns (if doesn't exist)
kubectl create ns kafka-ns

# Create a test pod in the kafka-ns namespace
kubectl run -n kafka-ns test-pod --image=busybox -- sleep 3600

# Test connectivity to Kafka (should failed as no one can access any pod by default)
kubectl exec -n kafka-ns test-pod -- nc -zv kafka-service.kafka-ns.svc.cluster.local 9092

# Create a test pod in the kafka-ns namespace with required labels
kubectl run test-pod -n kafka-ns --image=busybox --labels="app=zookeeper" -- sleep 3600

# Test connectivity to Kafka (should works as pod with labels "app=zookeeper" can access kafka)
kubectl exec -n kafka-ns test-pod -- nc -zv kafka-service.kafka-ns.svc.cluster.local 9092
```

### Testing RBAC Restrictions

```bash
I will update soon...
```

### Testing Kyverno Policies

```bash
# Create test namespace
kubectl create ns test
# Test policy that prevents using 'latest' tag (should be rejected)
kubectl apply -f - <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: nginx-latest
  namespace: test
spec:
  containers:
  - name: nginx
    image: nginx:latest
EOF

# Test policy that ensures resource limits (should be rejected)
kubectl apply -f - <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: unlimited-resources
  namespace: test
spec:
  containers:
  - name: nginx
    image: nginx:1.19
EOF
```

## 📊 Security Monitoring

The project includes monitoring for security events:

- Runtime anomaly detection
- RBAC violation logging
- Network policy violations
- Compliance monitoring

## 🛠️ Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- Kubernetes Security Best Practices
- CNCF Security Technical Advisory Group
- Zero Trust Security Model
