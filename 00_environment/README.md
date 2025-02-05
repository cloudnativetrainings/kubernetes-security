# Learning about the Envrionment

In this lab you will learn about the environment you will be using.

## Inspect Kubernetes Installation

### kubeconfig

```bash
# check nodes of cluster
kubectl get nodes

# inspect kubeconfig
cat ~/.kube/config

# get current context
kubectl config current-context
```

### kubeadm

```bash
# check possible upgrades of cluster
kubeadm upgrade plan

# check expiry date of cluster-internal certificates
kubeadm certs check-expiration

# print out join command for additional nodes
kubeadm token create --print-join-command
```

### kubelet

```bash
# check the status of the kubelet
systemctl status kubelet

# check the unit file of the kubelet service
cat /usr/lib/systemd/system/kubelet.service.d/10-kubeadm.conf

# check the configuration of the kubelet => take a look at the value of the field staticPodPath
cat /var/lib/kubelet/config.yaml

# check the static pod manifests (which the kubelet will take care of)
cd /etc/kubernetes/manifests/
```

#### Create a static pod

Create the following static pod manifest in the file `/etc/kubernetes/manifests/my-static-pod.yaml`

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

Verify the static pod was started by the kubelet.

```bash
kubectl get pods
```

> Note that the name of the pod is a combination of the pod name and the node name.

Remove the static pod again.

```bash
# remove the static manifest
rm /etc/kubernetes/manifests/my-pod.yaml

# verify pod is not running anymore
kubectl get pods
```

### crictl

Instead of `docker` we are using `containerd` Container Runtime Engine (CRE). For interaction with the CRE we are using the tool `crictl`.

```bash
# get all running containers
crictl ps

# get the kube-apiserver container
crictl ps | grep kube-apiserver

# get logs of kube-apiserver
crictl logs <FIRST-LETTERS-OF-CONTAINER-ID>
```

### cni plugin

We are using Calico CNI-plugin.

```bash
# take a look at the configuration of the cni-plugin
ls -alh /etc/cni/net.d/
```
