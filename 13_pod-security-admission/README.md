# Pod Security Admission

In this lab you will learn how to get a base set of security via vanilla Kubernetes.

## Installation

```bash
# add PodSecurity Admission Plugin in /etc/kubernetes/manifests/kube-apiserver.yaml
- --enable-admission-plugins=NodeRestriction,PodSecurity # <= add PodSecurity
```

## Enable Baseline Standard on Namespace

```bash
kubectl edit ns default
```

```yaml
apiVersion: v1
kind: Namespace
metadata:
  labels:
    pod-security.kubernetes.io/enforce: baseline # <= add this label
name: default
```

> Note, you get already get a warning about the running Pod.

## Try to re-deploy the pod

```bash
kubectl delete pod my-suboptimal-pod
kubectl apply -f pod.yaml
```

> Note, you get an error.

## Switch to warnings instead of errors

```bash
kubectl edit ns default
```

```yaml
apiVersion: v1
kind: Namespace
metadata:
  labels:
    pod-security.kubernetes.io/warn: baseline # <= change enforce to warn
name: default
```

## Try to re-deploy the pod again

```bash
kubectl apply -f pod.yaml
```

> Note, you now get a warning.

## Cleanup

```bash
kubectl edit ns default
```

```yaml
apiVersion: v1
kind: Namespace
metadata:
  labels:
    pod-security.kubernetes.io/warn: baseline # <= delete this line
name: default
```
