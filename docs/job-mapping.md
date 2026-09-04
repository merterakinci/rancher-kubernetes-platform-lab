# Job Requirement Mapping

This project is designed as a practical Kubernetes administration laboratory aligned with the target Kubernetes infrastructure administrator role.

## Kubernetes Administration

Job requirement: Kubernetes platform administration.

Project evidence:
- Kubernetes cluster lifecycle with Minikube
- Deployments, Services and Ingress
- ResourceQuota
- HPA
- NetworkPolicy
- RBAC
- Pod Security Standards

## Rancher / RKE2 Concepts

The local lab does not claim production Rancher experience. The architecture documentation maps the local Kubernetes implementation to a production-oriented Rancher/RKE2 platform design.

## Helm

Project evidence:
- Helm chart structure
- values.yaml configuration
- Helm lint
- Helm template validation
- Helm upgrade and rollback workflow

## Terraform

Project evidence:
- Terraform-managed Kubernetes namespace
- ResourceQuota managed as infrastructure code
- terraform fmt and validate
- Terraform state and provider configuration

## Security

Project evidence:
- Non-root container
- Read-only root filesystem
- Dropped Linux capabilities
- Seccomp RuntimeDefault
- ServiceAccount token disabled for the application
- Least-privilege RBAC observer account
- NetworkPolicy
- Pod Security Standards

## Load Balancing and Ingress

Project evidence:
- NGINX Ingress controller
- Kubernetes Ingress resource
- HTTP routing using platform.local
- End-to-end request validation

## Storage

Project evidence:
- MinIO S3-compatible storage component
- Kubernetes-based storage service deployment
- Architecture documentation for production Ceph/S3 integration

## Observability

Project evidence:
- Metrics Server
- kubectl top
- HPA based on CPU utilization
- Health probes
- Kubernetes events and logs

## CI/CD and DevSecOps

Project evidence:
- GitHub Actions workflow
- Helm validation
- Terraform validation
- Python tests
- Docker build
- Trivy security scanning

## Important Scope Statement

This repository demonstrates hands-on Kubernetes platform engineering concepts in a controlled laboratory environment. It must not be presented as evidence of production Rancher, RKE2, Ceph, HAProxy, GPU cluster or data-center administration experience.
