# Kubernetes Fundamentals

## Setup Training Environment

```bash

# git clone
git clone https://github.com/stroebitzer/kubermatic-heise-kubernetes-security.git

# [executed localy]
gcloud init

# [executed localy] create the VM
make setup

# verify
gcloud compute instances list

# ssh into the new VM
gcloud compute ssh root@kubernetes-security --zone europe-west3-a

# follow installation
tail -f /var/log/cloud-init-output.log

# verify cloud-init finished successfully
cat /var/log/cloud-init-output.log | grep "CloudInit Finished Successfully"

# verify single node Kubernetes cluster
kubectl get nodes

# verify bash completion is in place
kubectl get node <TAB>

# why is completion in place?
cat ~/.trainingrc

# verify that a single pod is running in the default namespace
kubectl get pods

# verify all tools got installed properly
make verify
```

## Inspect Kubernetes Installation

### kubeconfig

```bash
# inspect kubeconfig
cat ~/.kube/config

# get current context
kubectl config current-context
```

### namespaces

```bash
kubectl get ns
kubens
cat ~/.kube/config | grep namespace
kubens kube-system
cat ~/.kube/config | grep namespace
kubens default
cat ~/.kube/config | grep namespace
kubens
```

### kubeadm

```bash
# play around with kubeadm
kubeadm --version
kubeadm upgrade plan
kubeadm certs check-expiration
kubeadm token create --print-join-command
```

### kubelet

```bash
systemctl status kubelet
cat cat /usr/lib/systemd/system/kubelet.service.d/10-kubeadm.conf
cat /var/lib/kubelet/config.yaml
cd /etc/kubernetes/manifests/
```

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: some-pod
spec:
  containers:
    - name: some-pod
      image: nginx
```

### crictl

```bash
crictl ps
crictl ps | grep some-pod # => pod name
crictl rm -f <CONTAINER-ID>

crictl ps | grep kube-apiserver
kubectl get nodes
crictl stop <CONTAINER-ID>
kubectl get nodes
```

### cni plugin

```bash
# CNI plugin
ls -alh /etc/cni/net.d/
```

## Teardown Training Environment

```bash
# [executed localy] destroy environment
make destroy
```
