# Static Analysis via Kubesec

## Install Kubesec

```bash
# https://kubesec.io/

# download and install kubesec
wget https://github.com/controlplaneio/kubesec/releases/download/v2.14.2/kubesec_linux_amd64.tar.gz
tar -xvf kubesec_linux_amd64.tar.gz
sudo mv kubesec /usr/local/bin/

# check if kubesec is installed on host level
kubesec version
```

## Run kubesec localy

```bash
# scan the pod yaml
kubesec scan pod.yaml

# => fix critical stuff
# => fix most of the advices

kubesec scan --help # => exit code for ci/cd

# apply the changes
kubectl apply -f pod.yaml --force
```

## Run kubesec localy as kubectl plugin

```bash
# https://krew.sigs.k8s.io/docs/user-guide/setup/install/
# https://github.com/controlplaneio/kubectl-kubesec

# install krew
(
  set -x; cd "$(mktemp -d)" &&
  OS="$(uname | tr '[:upper:]' '[:lower:]')" &&
  ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" &&
  KREW="krew-${OS}_${ARCH}" &&
  curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" &&
  tar zxvf "${KREW}.tar.gz" &&
  ./"${KREW}" install krew
)
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
kubectl krew --help

# install kubesec-scan kubectl plugin
# https://krew.sigs.k8s.io/plugins/
kubectl krew search kubesec-scan
kubectl krew install kubesec-scan

# investigate krew mechanisms
ls -alh ~/.krew/bin/
kubectl krew list
kubectl plugin list
cat ~/.krew/receipts/kubesec-scan.yaml

# hint to sniff / wireshark

# scan running pod
kubectl kubesec-scan pod my-suboptimal-pod
```

## Run as Admission Webhook

```bash
# https://artifacthub.io/packages/helm/kubesec/kubesec

helm repo add kubesec https://abarrak.github.io/kubesec-helm
helm repo ls
helm repo update

helm --namespace kubesec --create-namespace --atomic upgrade --install \
  kubesec-scanner kubesec/kubesec --set mode=cron

# TODO does not work

```

## Run as Cronjob

```bash
# TODO
```
