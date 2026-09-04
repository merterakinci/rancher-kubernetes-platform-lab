# Testing and Validation

## Static Validation

Helm:

```bash
helm lint ./helm/platform-api
helm template platform-api ./helm/platform-api -n platform
```

Terraform:

```bash
terraform -chdir=terraform fmt -check
terraform -chdir=terraform validate
```

## Application Tests

```bash
pytest -q
```

## Container Build

```bash
docker build -t platform-api:ci ./app
```

## Security Scan

```bash
trivy fs --severity HIGH,CRITICAL .
```

## Kubernetes Validation

```bash
kubectl get deployment,svc,ingress,hpa,networkpolicy,resourcequota -n platform
```

## Security Context Validation

Confirm that the application runs as the dedicated non-root UID:

```bash
kubectl exec -n platform deploy/platform-api -- id
```

Expected UID:

```text
uid=10001
```

## HPA Validation

```bash
kubectl get hpa -n platform
kubectl top pods -n platform
```

The lab was tested with HTTP load and demonstrated scale-out from 2 replicas and scale-back after load removal.

## End-to-End Ingress Validation

```bash
sudo minikube tunnel
curl -i -H \"Host: platform.local\" http://127.0.0.1/
```

The expected result is HTTP 200 from platform-api through the NGINX Ingress controller.
