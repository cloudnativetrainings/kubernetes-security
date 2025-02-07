# Apiserver not starting

In this lab you will learn how to debug non-starting apiservers.

## Container can start, but the process fails

```bash
# add to /etc/kubernetes/manifest/kube-apiserver.yaml
- --this-is-wrong=true

# now the apiserver is down and cannort restart again, due do misconfiguration
kubectl get nodes

# get state of apiserver => due to apiserver is down it is not in
crictl ps | grep kube-apiserver

# get the state of the apiserver => now you see it is in state `Exited`
crictl ps -a | grep kube-apiserver

# get the reason why it has not started
crictl logs <CONTAINER_ID>

# fix issue again => remove wrong param, afterwards the kube-apiserver should start again
crictl ps | grep kube-apiserver # => now in there again
kubectl get nodes
```

## The kubelet cannot start the container

Provoke another error again => /etc/kubernetes/manifest/kube-apiserver.yaml

```yaml
volumes:
  - name: lod-apiserver
    hostPath:
      path: /root/apiserver
      type: File # <= WRONG
```

The apiserver is down again, and will not restart. In this case the kubelet is not able to start the container, so you will not get any logs.

```bash
# try to find the issue via container logs
kubectl get nodes # => does not work
crictl ps -a | grep kube-apiserver # => not in there
crictl logs <CONTAINER_ID> # => not doable

# try to find the issue via syslog
journalctl # => nope, too much information
journalctl -u kubelet # => nope, too much information
journalctl -u kubelet | grep kube-apiserver # => yes, but still too much information
journalctl -u kubelet | grep kube-apiserver | grep lod-apiserver # => yes

# fix volume again => DirectoryOrCreate
kubectl get nodes
```
