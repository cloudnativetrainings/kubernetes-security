# MLA

In this lab you will setup an MLA stack for security.

```bash
# switch into the right directory
cd 24_mla
```

## Prometheus

```bash
# install
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm --namespace mla --create-namespace --atomic --debug \
  upgrade --install \
  prometheus prometheus-community/kube-prometheus-stack --version v66.3.1 \
  --values prometheus-stack-values.yaml

# verify
kubectl --namespace mla get pods
kubectl --namespace mla get svc

# visit prometheus, you can find your external ip in the ssh-config file
# you can see the ports of the nodeport services via
kubectl --namespace mla get svc
# => http://EXTERNAL_IP:30090

# => add the following promql into the searchbox and switch to graph view
# => node_memory_Active_bytes

# visit alertmanager
# => http://EXTERNAL_IP:30903

# visit grafana
# => http://EXTERNAL_IP:31715 (admin/password753)
```

## trivy

```bash
# run an image with security issues
kubectl run ancient-elasticsearch --image elasticsearch:6.8.21

# install
helm repo add trivy-operator https://aquasecurity.github.io/helm-charts/
helm repo update
helm --namespace trivy --create-namespace --atomic --debug \
  upgrade --install \
  trivy-operator aqua/trivy-operator --version 0.24.1 \
  --set compliance.cron="*/10 * * * *" \
  --set targetNamespaces="default"

# verify if trivy created a vulnerabilityreport
kubectl get vulnerabilityreports --all-namespaces -o wide

# verify in prometheus if vulnerabilityreport got into prometheus db
# promql => trivy_image_vulnerabilities{namespace="default"}

# import the trivy-operator dashboard 17813 in grafana
# https://grafana.com/grafana/dashboards/17813-trivy-operator-dashboard/
```

## kyverno

```bash
# install
helm repo add kyverno https://kyverno.github.io/kyverno/
helm repo update
helm --namespace kyverno --create-namespace --atomic --debug \
  upgrade --install \
  kyverno kyverno/kyverno --version 3.3.4 \
  --values kyverno-values.yaml

# Import Kyverno Dashboard into Grafana
# https://github.com/kyverno/kyverno/blob/main/charts/kyverno/charts/grafana/dashboard/kyverno-dashboard.json

# apply the policy
kubectl apply -f disallow-latest-tag.yaml

# trigger a violation
kubectl delete pod my-suboptimal-pod
kubectl apply -f ../pod.yaml

# verify in grafana
# verify in prometheus
# promql => kyverno_admission_requests_total{"resource_namespace"="default"}
```

## Falco

```bash
# install
helm repo add falcosecurity https://falcosecurity.github.io/charts
helm repo update
helm --namespace falco --create-namespace --atomic --debug \
  upgrade --install \
  falco falcosecurity/falco --version 4.17.0 \
  --values falco-values.yaml

# verify
kubectl -n falco get pods
kubectl -n falco logs <FALCO_POD_NAME>

# trigger falco alert
kubectl run some-pod --image ubuntu:22.04 --command -- sleep 1h
kubectl exec -it some-pod -- bash

# verify falco detected it
kubectl -n falco logs <FALCO_POD_NAME> | grep "A shell was spawned"

# add the falco-exporter
helm --namespace falco-exporter --create-namespace --atomic --debug \
  upgrade --install \
  falco falcosecurity/falco-exporter --version 0.12.1 \
  --values falco-exporter-values.yaml

# wait until the pod is in state RUNNING
kubectl -n falco-exporter get pods

# trigger falco alert
kubectl run some-pod --image ubuntu:22.04 --command -- sleep 1h
kubectl exec -it some-pod -- bash

# verify in grafana
# verify in prometheus
# promql => falco_events{k8s_ns_name="default"}
```
