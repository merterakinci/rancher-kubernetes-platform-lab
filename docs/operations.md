# Operations Guide

## Cluster Health

```bash
kubectl get nodes
kubectl get pods -A
kubectl get events -A --sort-by=.lastTimestamp
```

## Application Health

```bash
kubectl get deployment -n platform
kubectl rollout status deployment/platform-api -n platform
kubectl get pods -n platform -o wide
```

## Resource Usage

```bash
kubectl top nodes
kubectl top pods -n platform
kubectl describe resourcequota platform-quota -n platform
```

## Horizontal Pod Autoscaling

```bash
kubectl get hpa -n platform -w
```

Generate HTTP load when testing HPA and observe replicas increasing from the configured minimum toward the maximum.

## Logs

```bash
kubectl logs -n platform deployment/platform-api
kubectl logs -n platform deployment/platform-api --previous
```

## Rollout and Rollback

```bash
helm upgrade platform-api ./helm/platform-api -n platform
kubectl rollout status deployment/platform-api -n platform
kubectl rollout history deployment/platform-api -n platform
kubectl rollout undo deployment/platform-api -n platform
```

## Troubleshooting

Check pod details:

```bash
kubectl describe pod -n platform <pod-name>
```

Check recent events:

```bash
kubectl get events -n platform --sort-by=.lastTimestamp
```

Check ingress:

```bash
kubectl describe ingress platform-api -n platform
kubectl get pods -n ingress-nginx
```
