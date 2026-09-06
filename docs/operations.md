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

## Real Incident: Node Resource Exhaustion (2026-09-06)

During operation, the Minikube node (8 vCPU / 6GiB, backed by an 8GB Mac
via Docker Desktop) entered severe CPU contention (run queue depth 40-120
on an 8-core system; load average peaked at 37.95).

Symptoms observed, in causal order:
1. Calico exec probes (`felix-live`, `bird-live`) timed out -> calico-node
   CrashLoopBackOff
2. New pod CNI attach (sandbox creation) stalled -> pods stuck in
   `ContainerCreating`
3. Pod-to-Service and pod-to-apiserver traffic timed out
   (`10.96.0.1:443` unreachable from pods, while node-to-apiserver worked)
4. metrics-server and Grafana liveness/readiness probes (1s-30s timeouts)
   fired before slow-starting processes could bind their ports ->
   CrashLoopBackOff on both

Diagnosis method: bypassed the Kubernetes Service layer to isolate pod
networking from Service NAT (`curl` directly against the node's API
endpoint `192.168.49.2:8443` from a debug pod), confirmed via `vmstat`
and `/proc/loadavg` that the bottleneck was CPU scheduling, not disk I/O
or Calico configuration.

Remediation:
- Added a `startupProbe` to Grafana to tolerate slow SQLite migrations
  under CPU pressure
- Relaxed metrics-server probe timeouts
- Right-sized `prometheusOperator`, `kube-state-metrics`, and
  `prometheus-node-exporter` resource requests/limits (previously
  unbounded) and increased Prometheus `scrapeInterval` to 60s to reduce
  steady-state CPU/disk load

Known limitation: an 8GB Mac running Docker Desktop + Minikube does not
have enough spare capacity to run the full kube-prometheus-stack
alongside the application workload without contention. In a real
Rancher/RKE2 deployment this class of problem is addressed with
dedicated monitoring nodes / node pools and PriorityClasses -- see
`docs/production-architecture.md`.
