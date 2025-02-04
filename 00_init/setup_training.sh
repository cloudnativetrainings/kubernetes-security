#!/bin/bash

echo "================================================= Init Training Script"

echo "================================================= Init Training Script - Install Tools"
git clone https://github.com/ahmetb/kubectx /opt/kubectx
ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx
ln -s /opt/kubectx/kubens /usr/local/bin/kubens

echo "================================================= Init Training Script - Install Helm"
curl https://baltocdn.com/helm/signing.asc | apt-key add -
echo "deb https://baltocdn.com/helm/stable/debian/ all main" | tee /etc/apt/sources.list.d/helm-stable-debian.list
apt update
DEBIAN_FRONTEND=noninteractive apt-get install helm --yes

echo "================================================= Init Training Script - Apply Kubernetes Manifests"
kubectl apply -f /root/pod.yaml
kubectl create clusterrolebinding my-suboptimal-clusterrolebinding --clusterrole=cluster-admin --serviceaccount default:default

echo "================================================= Init Training Script - Patching Kubelet"
mkdir -p /root/tmp
sed  's/    enabled: false/    enabled: true/g' /var/lib/kubelet/config.yaml > /root/tmp/kubelet-1.yaml
sed  's/  mode: Webhook/  mode: AlwaysAllow/g' /root/tmp/kubelet-1.yaml > /root/tmp/kubelet-2.yaml
mv /root/tmp/kubelet-2.yaml /var/lib/kubelet/config.yaml
systemctl daemon-reload
systemctl restart kubelet

echo "================================================= Init Training Script - Patching API-Server"
mkdir -p /root/apiserver
mkdir -p /root/tmp
sed  '/  volumes:/a \
  - name: lod-apiserver\
    hostPath:\
      path: /root/apiserver\
      type: DirectoryOrCreate' /etc/kubernetes/manifests/kube-apiserver.yaml > /root/tmp/apiserver-1.yaml
sed  '/  volumeMounts:/a \
    - name: lod-apiserver\
      mountPath: /apiserver' /root/tmp/apiserver-1.yaml > /root/tmp/apiserver-2.yaml
mv /root/tmp/apiserver-2.yaml /etc/kubernetes/manifests/kube-apiserver.yaml

echo "================================================= Init Training Script - Install ETCD Client"
DEBIAN_FRONTEND=noninteractive apt-get install etcd-client --yes

echo "================================================= Init Training Script - Finished Successfully"
