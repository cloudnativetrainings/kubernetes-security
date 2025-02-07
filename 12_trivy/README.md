# Image Scanning via Trivy

In this lab you will learn how to scan images with the tool trivy.

## Run Trivy localy

### Scan localy

```bash
# scan the latest image of nginx
trivy image nginx

# scan for critical issues of the latest image of nginx
trivy image --severity CRITICAL nginx

# scan the latest alpine image
trivy image alpine

# scan an older elasticsearch image
# note that the report contains Log4Shell CVE-2021-44228 => so, also the dependencies of the application get scanned
trivy image --severity CRITICAL elasticsearch:6.8.21
```

### Scan in CI/CD

```bash
# exit code for CI/CD
trivy k8s --help | grep exit
```

### Scan a Kubernetes Cluster, but still localy

```bash
# scan the kubernetes cluster
trivy k8s --report summary
trivy k8s --include-namespaces default --report=summary
trivy k8s --include-namespaces default --severity MEDIUM --report=summary
trivy k8s --include-namespaces default --severity MEDIUM,HIGH,CRITICAL --report=summary
trivy k8s --include-namespaces default --severity MEDIUM,HIGH,CRITICAL --report all

# .trivyignore
trivy k8s --include-namespaces default --severity HIGH,CRITICAL --report all
echo "AVD-KSV-0121" > .trivyignore
trivy k8s --include-namespaces default --severity HIGH,CRITICAL --report all
```

## Run Trivy via Operator

```bash
# install helm chart
helm repo add aqua https://aquasecurity.github.io/helm-charts/
helm repo update
helm --namespace trivy --create-namespace --atomic --debug \
  upgrade --install \
  trivy-operator aqua/trivy-operator --version 0.24.1

# verify installation
helm list -n trivy

# take a look at the new resources
kubectl api-resources | grep aqua

# get reports => will probably not work, takes some time for the first report
kubectl get vulnerabilityreports --all-namespaces -o wide

# you can check the state of the first scan via
kubectl -n trivy logs deployment/trivy-operator
kubectl -n trivy get pods

# after the jobs have completed you should get reports
kubectl get vulnerabilityreports --all-namespaces -o wide

# see vulnerabilities of my-suboptimal-pod
kubectl -n default describe vulnerabilityreports pod-my-suboptimal-pod-my-ubuntu

# configure to run scans each 10 minutes
helm --namespace trivy --create-namespace --atomic --debug \
  upgrade --install \
  trivy-operator aqua/trivy-operator --version 0.24.1 \
  --set compliance.cron="*/10 * * * *" \
  --set targetNamespaces="default"

# verify setting
helm -n trivy get values trivy-operator
```

## Cleanup

```bash
helm --namespace trivy uninstall trivy-operator
```
