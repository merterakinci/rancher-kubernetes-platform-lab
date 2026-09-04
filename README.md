# Rancher Kubernetes Platform Lab

Production-oriented Kubernetes platform administration laboratory built with Minikube, Helm and Terraform.

## Architecture

```text
Terraform
  |
  +--> Namespace
  |
  +--> ResourceQuota

Helm
  |
  +--> Deployment
  +--> Service
  +--> Ingress
  +--> HPA
  +--> NetworkPolicy
  +--> ServiceAccount

Metrics Server
  |
  +--> HPA
```

## Technology Stack

- Kubernetes
- Minikube
- Helm
- Terraform
- Docker
- NGINX Ingress
- Metrics Server
- Kubernetes RBAC
- NetworkPolicy
- Pod Security Standards
- Python / Flask
- MinIO / S3-compatible storage
- GitHub Actions
- Trivy

## Implemented Capabilities

- Kubernetes workload deployment
- Helm-based application packaging
- Terraform-managed namespace and resource quotas
- NGINX Ingress routing
- Horizontal Pod Autoscaling
- Metrics Server integration
- Kubernetes RBAC
- NetworkPolicy
- Non-root containers
- Read-only root filesystem
- Dropped Linux capabilities
- Seccomp RuntimeDefault
- Pod Security Standards
- Resource requests and limits
- Liveness and readiness probes
- CI validation and container security scanning

## Validation

- Helm lint and template validation
- Terraform fmt and validate
- Python unit tests
- Docker image build
- Trivy filesystem scan
- Kubernetes deployment validation
- Ingress end-to-end HTTP test
- HPA scale-up and scale-down test
- RBAC verification
- NetworkPolicy verification
- ResourceQuota verification

## Environment

This repository is a local Kubernetes administration laboratory.

It does not claim production Kubernetes or Rancher administration experience.

The architecture documentation describes how the same concepts could be extended to a production environment using Rancher/RKE2, HAProxy/load balancing, image registry, Ceph/S3 storage and centralized observability.

## Documentation

- Architecture: docs/architecture.md
- Deployment: docs/deployment.md
- Operations: docs/operations.md
- Security: docs/security.md
- Testing: docs/testing.md
- Job Mapping: docs/job-mapping.md
