# Kubernetes Security Training

## Connect to the VM

Copy the files `ssh-private-key` and `ssh-config` to your codespace.

```bash
# Fix the permissions of your private key
chmod 0400 ./ssh-private-key

# Connect to your VM
ssh -F ./ssh-config ks-hubert-01
```
