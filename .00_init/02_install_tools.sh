#!/bin/bash

set -euxo pipefail

echo "================================================= Install Tools Script"

echo "================================================= Install Tools Script - Install Tools"
git clone https://github.com/ahmetb/kubectx /opt/kubectx
# TODO pin version?
ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx
ln -s /opt/kubectx/kubens /usr/local/bin/kubens

echo "================================================= Install Tools Script - Install Helm"
curl https://baltocdn.com/helm/signing.asc | apt-key add -
echo "deb https://baltocdn.com/helm/stable/debian/ all main" | tee /etc/apt/sources.list.d/helm-stable-debian.list
apt update
# TODO pin version?
DEBIAN_FRONTEND=noninteractive apt-get install helm --yes

echo "================================================= Install Tools Script - Install ETCD Client"
# TODO pin version?
DEBIAN_FRONTEND=noninteractive apt-get install etcd-client --yes

# TODO pin version? => check the whole script for pinning that stuff

echo "================================================= Install Tools Script - Install kubesec"
wget https://github.com/controlplaneio/kubesec/releases/download/v2.14.2/kubesec_linux_amd64.tar.gz
tar -xvf kubesec_linux_amd64.tar.gz
mv kubesec /usr/local/bin/

echo "================================================= Install Tools Script - Install trivy"
apt-get install wget apt-transport-https gnupg lsb-release
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
echo deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main | sudo tee -a /etc/apt/sources.list.d/trivy.list
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install trivy --yes

echo "================================================= Install Tools Script - Install strace"
DEBIAN_FRONTEND=noninteractive apt-get install strace --yes

echo "================================================= Install Tools Script - Install apparmor"
DEBIAN_FRONTEND=noninteractive apt-get install apparmor-utils --yes

echo "================================================= Install Tools Script - Install gvisor"
DEBIAN_FRONTEND=noninteractive apt-get install -y apt-transport-https ca-certificates curl gnupg
curl -fsSL https://gvisor.dev/archive.key | gpg --dearmor -o /usr/share/keyrings/gvisor-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/gvisor-archive-keyring.gpg] https://storage.googleapis.com/gvisor/releases release main" | tee /etc/apt/sources.list.d/gvisor.list > /dev/null
apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y runsc
sed -i '/\[plugins."io.containerd.grpc.v1.cri".containerd.runtimes\.runc\]/i \
        [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runsc]\n          runtime_type = "io.containerd.runsc.v1"\n' /etc/containerd/config.toml
systemctl restart containerd

echo "================================================= Install Tools Script - Install falco"
curl -fsSL https://falco.org/repo/falcosecurity-packages.asc | gpg --dearmor -o /usr/share/keyrings/falco-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/falco-archive-keyring.gpg] https://download.falco.org/packages/deb stable main" | tee -a /etc/apt/sources.list.d/falcosecurity.list
apt-get update -y
DEBIAN_FRONTEND=noninteractive apt-get install -y dkms make linux-headers-$(uname -r)
DEBIAN_FRONTEND=noninteractive apt-get install -y clang llvm
DEBIAN_FRONTEND=noninteractive FALCO_FRONTEND=noninteractive apt-get install --yes falco=0.38.0

echo "================================================= Install Tools Script - Finished Successfully"
