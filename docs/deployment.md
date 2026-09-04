# Deployment Guide

## Prerequisites

- macOS or Linux
- Docker
- Minikube
- kubectl
- Helm
- Terraform

## Start the Kubernetes Environment

```bash
minikube start --driver=docker
minikube addons enable ingress
minikube addons enable metrics-server
```

Verify the cluster:

```bash
kubectl get nodes
kubectl get pods -A
```

## Deploy the Platform

Create the namespace and supporting resources:

```bash
kubectl apply -f k8s/security/namespace.yaml
kubectl apply -f k8s/security/platform-observer-rbac.yaml
kubectl apply -f k8s/storage/minio.yaml
```

Initialize Terraform:

```bash
cd terraform
terraform init
terraform validate
terraform apply
cd ..
```

Build the application image:

```bash
docker build -t platform-api:ci ./app
minikube image load platform-api:ci
```

Deploy with Helm:

```bash
helm upgrade --install platform-api ./helm/platform-api -n platform --create-namespace
```

## Verify the Deployment

```bash
kubectl get pods -n platform
kubectl get svc -n platform
kubectl get ingress -n platform
kubectl get hpa -n platform
kubectl get networkpolicy -n platform
kubectl get resourcequota -n platform
```

## Ingress Test

With Minikube Docker networking, use the Minikube tunnel:

```bash
sudo minikube tunnel
```

In another terminal:

```bash
curl -H \"Host: platform.local\" http://127.0.0.1/
```

Expected response contains the platform-api service name and pod hostname.
