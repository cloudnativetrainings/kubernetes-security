## ApiServer not starting

```bash
# add to /etc/kubernetes/manifest/kube-apiserver.yaml
- --this-is-wrong=true

kubectl get nodes # => does not work
crictl ps # => too much info
crictl ps | grep kube-apiserver # => not in there
crictl ps -a | grep kube-apiserver # => not in there
crictl logs <CONTAINER_ID>

# fix issue again => remove wrong param

crictl ps -a | grep kube-apiserver # => now in there again
kubectl get nodes

# provoke another error again => /etc/kubernetes/manifest/kube-apiserver.yaml
volumes:
  - name: lod-apiserver
    hostPath:
      path: /root/apiserver
      type: File # <= WRONG

kubectl get nodes # => does not work
crictl ps -a | grep kube-apiserver # => not in there
crictl logs <CONTAINER_ID> # => not doable

journalctl # => nope
journalctl -u kubelet # => nope
journalctl -u kubelet | grep kube-apiserver # => yes, but
journalctl -u kubelet | grep kube-apiserver | grep lod-apiserver # => yes

# fix volume again => DirectoryOrCreate

kubectl get nodes

```
