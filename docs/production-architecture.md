# Production Kubernetes Architecture

## Purpose

This document describes the target production-oriented architecture that the local Kubernetes laboratory could evolve toward.

The production design is intentionally separated from the validated local implementation. Components described here as target architecture are not claimed as production experience.

## High-Level Architecture

```text
                         Internet
                            |
                     +------+------+
                     | HAProxy / LB |
                     +------+------+
                            |
              +-------------+-------------+
              |     Rancher / RKE2       |
              |    Kubernetes Platform   |
              +-------------+-------------+
                            |
          +-----------------+-----------------+
          |                 |                 |
    +-----+-----+     +-----+-----+     +-----+-----+
    | Control   |     | Worker    |     | GPU       |
    | Plane HA  |     | Nodes     |     | Workers   |
    +-----------+     +-----------+     +-----------+
          |                 |                 |
          +-----------------+-----------------+
                            |
              +-------------+-------------+
              |                           |
        +-----+------+              +-----+------+
        | Harbor     |              | Ceph / S3  |
        | Registry   |              | Storage    |
        +------------+              +------------+
                            |
                    +-------+-------+
                    | Observability |
                    | Prometheus    |
                    | Grafana       |
                    | Loki          |
                    +---------------+
```

## Kubernetes Management

Rancher is the intended management layer for the production platform. RKE2 is considered the Kubernetes distribution for the target architecture.

The local Minikube environment demonstrates Kubernetes administration concepts without pretending to reproduce a multi-node production control plane.

## High Availability

The target platform should use multiple control-plane nodes and multiple worker nodes.

Key objectives:
- eliminate single points of failure
- support workload rescheduling
- provide controlled maintenance and rolling upgrades
- separate control-plane and workload responsibilities

An external load balancer such as HAProxy can provide ingress and API endpoint load distribution.

## Container Registry

Harbor is the target private container registry.

Expected responsibilities:
- store versioned container images
- provide image scanning
- support controlled image promotion
- integrate with CI/CD pipelines
- provide authenticated image access to Kubernetes nodes

## Storage

The target architecture uses Ceph and/or S3-compatible object storage depending on workload requirements.

Typical separation:
- block storage for persistent Kubernetes workloads
- object storage for backups and application data
- replicated storage for resilience

The current lab uses MinIO as an S3-compatible storage component.

## Observability

The production design includes centralized metrics, dashboards and logs.

Prometheus:
- Kubernetes and application metrics
- alerting rules
- capacity monitoring

Grafana:
- operational dashboards
- cluster health visualization
- workload and resource dashboards

Loki:
- centralized log aggregation
- application and Kubernetes log investigation

The current lab validates basic metrics through Metrics Server and uses HPA based on CPU utilization.

## GPU Worker Pool

For AI workloads, dedicated GPU worker nodes can be separated from general-purpose application nodes.

The production design may include NVIDIA GPU-enabled nodes, device plugins and workload scheduling through Kubernetes labels, taints and tolerations.

The local lab does not contain H200, RTX 6000 or equivalent production GPU hardware.

## Security Architecture

Security controls demonstrated in the local lab should remain part of the production design:

- least-privilege RBAC
- NetworkPolicy
- non-root containers
- read-only root filesystem where possible
- dropped Linux capabilities
- seccomp
- resource requests and limits
- health probes
- private image registry
- centralized monitoring and logging

Production environments would additionally require hardened node configuration, secrets management, image signing/scanning, backup procedures and controlled administrative access.

## Infrastructure as Code

Terraform is used in the laboratory to manage Kubernetes resources.

Ansible can complement Terraform for operating-system configuration, node preparation and repeatable infrastructure administration.

The intended division is:

- Terraform: infrastructure and declarative platform resources
- Ansible: host configuration and operational automation
- Helm: Kubernetes application packaging
- GitHub Actions: CI validation and security checks

## Failure Domains

The production architecture should consider failure at several levels:

1. Application pod failure
2. Worker node failure
3. Control-plane node failure
4. Load balancer failure
5. Storage failure
6. Registry failure
7. Availability-zone or physical-host failure

Workloads, storage and management components should be designed according to the required recovery objectives.

## Local Lab vs Production Target

| Capability | Local Lab | Production Target |
|---|---|---|
| Kubernetes | Minikube | RKE2 |
| Management | kubectl | Rancher |
| Ingress | NGINX | NGINX / Load Balancer |
| Load Balancer | Minikube tunnel | HAProxy / enterprise LB |
| Registry | Local Docker image | Harbor |
| Storage | MinIO | Ceph / S3 |
| Metrics | Metrics Server | Prometheus |
| Dashboards | kubectl metrics | Grafana |
| Logs | kubectl logs | Loki / centralized logging |
| Automation | Terraform | Terraform + Ansible |
| GPU | Not available | Dedicated NVIDIA worker pool |

## Scope Statement

This architecture is a design target for the laboratory. It should not be interpreted as evidence of production Rancher, RKE2, Ceph, HAProxy, GPU or data-center administration experience.
