# Runtime Security with Falco

## Installation

```bash
# install
curl -fsSL https://falco.org/repo/falcosecurity-packages.asc | gpg --dearmor -o /usr/share/keyrings/falco-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/falco-archive-keyring.gpg] https://download.falco.org/packages/deb stable main" | tee -a /etc/apt/sources.list.d/falcosecurity.list
apt-get update -y
DEBIAN_FRONTEND=noninteractive apt-get install -y dkms make linux-headers-$(uname -r)
DEBIAN_FRONTEND=noninteractive apt-get install -y clang llvm
DEBIAN_FRONTEND=noninteractive FALCO_FRONTEND=noninteractive apt-get install --yes falco=0.38.0

# verify
systemctl status falco-modern-bpf.service
```

## Configure Falco

Edit the Falco configuration file

```bash
vi /etc/falco/falco.yaml
```

Configure the `file_output` section to the following.

```yaml
file_output:
  enabled: true
  keep_alive: false
  filename: /var/log/falco.log
```

## Verify logging

```bash
# verify no logs
cat /var/log/falco.log

# exec into the pod (and exit afterwards)
kubectl exec -it my-suboptimal-pod -- bash

# verify that a line like this got logged
cat /var/log/falco.log 
```

## Configure Rules

```bash
# check falco dir
ls -alh /etc/falco

# find rule
vi /etc/falco/falco_rules.yaml

# adapt rule
vi /etc/falco/falco_rules.local.yaml 

# show supported fields => https://falco.org/docs/reference/rules/supported-fields/
# => change prio from NOTICE to WARNING

# exec into the pod (and exit afterwards)
kubectl exec -it my-suboptimal-pod -- bash

# verify that a line like this got logged
cat /var/log/falco.log 
```