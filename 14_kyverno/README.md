# Admission Control with Kyverno

## Installation

```bash
# install
helm repo add kyverno https://kyverno.github.io/kyverno/
helm repo update
helm --namespace kyverno --create-namespace --atomic --debug \
  upgrade --install \
  kyverno kyverno/kyverno --version v3.3.3

# verify installation
helm list -n kyverno

# take a look at the new resources
kubectl api-resources | grep kyverno

# check webhooks
kubectl get validatingwebhookconfigurations

# check deployments
kubectl -n kyverno get deployment
```

## Apply a ClusterPolicy

### Avoid new Pods breaking policys

```bash
# inspect the cluster policy
cat 14_kyverno/disallow-latest-tag.yaml

# apply the cluster policy
kubectl apply -f 14_kyverno/disallow-latest-tag.yaml
kubectl get clusterpolicies.kyverno.io

# delete the pod
kubectl delete pod my-suboptimal-pod

# try to apply the pod - note you will get an error due to no image tag is provided
kubectl apply -f pod.yaml

# add the image tag to the image, eg `image: ubuntu:22.04`. Re-run the apply command. Now it works again
kubectl apply -f pod.yaml
```

### Report existing Pods breaking policys

```bash
# delete the policy
kubectl delete -f 14_kyverno/disallow-latest-tag.yaml

# remove the image tag in the pod and create the pod
kubectl apply -f pod.yaml

# change the background flag in the policy to `true`
vi 14_kyverno/disallow-latest-tag.yaml

# apply the cluster policy
kubectl apply -f 14_kyverno/disallow-latest-tag.yaml
kubectl get clusterpolicies.kyverno.io

# pod is still running
kubectl get pods

# check reports, note that the report has result `fail`
kubectl get policyreports
kubectl describe policyreports <REPORT>
```

## Cleanup

```bash
helm --namespace kyverno delete kyverno
```
