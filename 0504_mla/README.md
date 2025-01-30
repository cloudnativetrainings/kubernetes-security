# MLA

In this lab you will setup an MLA stack for security.

```bash
cd 0504_mla
```

## Prometheus

```bash
# https://artifacthub.io/packages/helm/prometheus-community/kube-prometheus-stack
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm --namespace mla --create-namespace --atomic --debug \
  upgrade --install \
  prometheus prometheus-community/kube-prometheus-stack --version v66.3.1 \
  --values prometheus-stack-values.yaml

# verify
kubectl --namespace mla get pods
kubectl --namespace mla get svc

# visit urls
make get-external-ip # in different cloud shell

# visit prometheus => http://EXTERNAL_IP:30090
# => promql => node_memory_Active_bytes

# visit alertmanager => http://EXTERNAL_IP:30903

# visit grafana => http://EXTERNAL_IP:31715 (admin/password753)
```

## trivy

```bash
# https://artifacthub.io/packages/helm/trivy-operator/trivy-operator
# https://github.com/vijaybiradar/Deploying-Trivy-Operator-with-kube-prometheus-stack-for-Enhanced-Kubernetes-Security
# https://www.aquasec.com/blog/kubernetes-benchmark-scans-trivy-cis-nsa-reports/

helm repo add trivy-operator https://aquasecurity.github.io/helm-charts/
helm repo update

helm --namespace trivy --create-namespace --atomic --debug \
  upgrade --install \
  trivy-operator trivy-operator/trivy-operator --version 0.25.0 \
  --values trivy-operator-values.yaml

kubectl get vulnerabilityreports --all-namespaces -o wide
kubectl get configauditreports --all-namespaces -o wide
kubectl get infraassessmentreports --all-namespaces -o wide
kubectl get rbacassessmentreports --all-namespaces -o wide
kubectl get exposedsecretreport --all-namespaces -o wide
kubectl get clustercompliancereport --all-namespaces -o wide

# promql => trivy_image_vulnerabilities

# Import trivy-operator Dashboard 17813
# https://grafana.com/grafana/dashboards/17813-trivy-operator-dashboard/

kubectl run ancient-elasticsearch --image elasticsearch:6.8.21

# promql => trivy_image_vulnerabilities

# Search Grafana trivy-operator dashboards
# https://grafana.com/grafana/dashboards/?dataSource=prometheus&search=trivy-operator

# Import trivy-operator Dashboard 17813
# https://grafana.com/grafana/dashboards/17813-trivy-operator-dashboard/

# install trivy cli
apt-get install wget apt-transport-https gnupg lsb-release
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
echo deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main | sudo tee -a /etc/apt/sources.list.d/trivy.list
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install trivy --yes

# NSA compliance check via CLI
trivy k8s --compliance=k8s-nsa-1.0 --report summary
trivy k8s --compliance=k8s-nsa-1.0 --report all
trivy k8s --compliance=k8s-nsa-1.0 --report all --output cis-report.json

# NSA compliance check via trivy-operator
kubectl get clustercompliancereport
kubectl get clustercompliancereport k8s-nsa-1.0 -o yaml
```

## kyverno

```bash
# https://artifacthub.io/packages/helm/kyverno/kyverno
# https://kyverno.io/docs/monitoring/
# https://kyverno.io/docs/monitoring/bonus-grafana-dashboard/
helm repo add kyverno https://kyverno.github.io/kyverno/
helm repo update
helm --namespace kyverno --create-namespace --atomic --debug \
  upgrade --install \
  kyverno kyverno/kyverno --version 3.3.4 \
  --values kyverno-values.yaml

# Import Kyverno Dashboard
# https://github.com/kyverno/kyverno/blob/main/charts/kyverno/charts/grafana/dashboard/kyverno-dashboard.json


kubectl apply -f disallow-latest-tag.yaml

# kubectl get policyreports

# trigger a violation
kubectl delete pod my-suboptimal-pod
kubectl apply -f ../pod.yaml

# promql => kyverno_admission_requests_total{"resource_namespace"="default"}

```

## Falco

```bash
# https://medium.com/@noah_h/kubernetes-security-tools-falco-e873831f3d3d
# https://falco.org/blog/falco-kind-prometheus-grafana/

helm repo add falcosecurity https://falcosecurity.github.io/charts
helm repo update

helm --namespace falco --create-namespace --atomic --debug \
  upgrade --install \
  falco falcosecurity/falco --version 4.17.0 \
  --values falco-values.yaml

kubectl -n falco get pods
kubectl -n falco logs falco-nccnc
kubectl run some-pod --image ubuntu:22.04 --command -- sleep 1h
kubectl exec -it some-pod -- bash
kubectl -n falco logs falco-nccnc | grep "A shell was spawned"

helm --namespace falco-exporter --create-namespace --atomic --debug \
  upgrade --install \
  falco falcosecurity/falco-exporter --version 0.12.1 \
  --values falco-exporter-values.yaml

kubectl -n falco-exporter get pods
kubectl -n falco-exporter get servicemonitor
# => check serviceexporter in prometheus
# promql => falco_events{k8s_ns_name="default"}
kubectl exec -it some-pod -- bash
# => check dashboard
```

## Debug ServiceMonitor Issues

```bash
# kubectl get prometheuses.monitoring.coreos.com --all-namespaces -o yaml | grep -C5 serviceMonitorSelector
# kubectl -n kyverno label servicemonitors kyverno-admission-controller release=prometheus
# kubectl -n kyverno get servicemonitors kyverno-admission-controller -o yaml
# kubectl -n mla delete pods --all
```

## Audit logs

## kube-bench

<!-- TODO -->

## Loki

```bash
# https://artifacthub.io/packages/helm/grafana/loki-stack

```
