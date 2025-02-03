# Pod Security Admission

## Installation

```bash
# via kube-apiserver-manifest
cat /etc/kubernetes/manifests/kube-apiserver.yaml | grep enable-admission-plugins

# add PodSecurity Admission Plugin in /etc/kubernetes/manifests/kube-apiserver.yaml
- --enable-admission-plugins=NodeRestriction,PodSecurity

```

## Enable Baseline Standard on Namespace

```yaml
apiVersion: v1
kind: Namespace
metadata:
  labels:
    pod-security.kubernetes.io/enforce: baseline # add
name: my-namespace
```

```bash
# add
kubectl edit ns default
```

## Verify Baseline Standard is working

```bash
kubectl delete pod my-suboptimal-pod

kubectl apply -f pod.yaml
```

## Fine-tune the PodSecurity Admission Controller

https://kubernetes.io/docs/tasks/configure-pod-container/enforce-standards-admission-controller/#configure-the-admission-controller
