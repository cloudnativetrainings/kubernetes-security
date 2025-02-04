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

echo "================================================= Install Tools Script - Finished Successfully"
