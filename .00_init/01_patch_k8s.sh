#!/bin/bash

set -euxo pipefail

echo "================================================= Patch K8s Script"

echo "================================================= Patch K8s Script - Patching Kubelet"
mkdir -p /root/tmp
sed  's/    enabled: false/    enabled: true/g' /var/lib/kubelet/config.yaml > /root/tmp/kubelet-1.yaml
sed  's/  mode: Webhook/  mode: AlwaysAllow/g' /root/tmp/kubelet-1.yaml > /root/tmp/kubelet-2.yaml
mv /root/tmp/kubelet-2.yaml /var/lib/kubelet/config.yaml
systemctl daemon-reload
systemctl restart kubelet

echo "================================================= Patch K8s Script - Patching API-Server"
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
sleep 1m # wait until API-Server is ready

echo "================================================= Patch K8s Script - Apply Kubernetes Manifests"
kubectl create clusterrolebinding my-suboptimal-clusterrolebinding --clusterrole=cluster-admin --serviceaccount default:default
sleep 2s # wait until SA is ready
kubectl apply -f /root/pod.yaml

echo "================================================= Patch K8s Script - Finished Successfully"
