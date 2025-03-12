# Kubernetes Security Training

## Setup the training environment

1. Open [Github Codespaces](https://github.com/codespaces) and create your new `cloudnativetrainings/kubernetes-security` codespace.
1. Copy the files `ssh-config` and `ssh-private-key` into your codespace.
1. Run the following commands:

```bash
# fix the permissions of your private key
chmod 0400 ./ssh-private-key

# connect to your VM
ssh -F ./ssh-config kubernetes-security-vm

# verify if everything is setup properly
make verify
```

## Teardown the training environment

1. Delete your `cloudnativetrainings/kubernetes-security` codespace via [Github Codespaces](https://github.com/codespaces).
