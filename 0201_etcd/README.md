# Encryption at Rest

## Install etcdctl

```bash
apt install -y etcd-client
```

<!-- TODO avoid apt dialog -->

## Communication with etcd

```bash
# verify etcdctl is installed
etcdctl --version

# does not work
etcdctl member list

# check how kube-apiserver talks to etcd
cat /etc/kubernetes/manifests/kube-apiserver.yaml | grep etcd
ls -alh /etc/kubernetes/pki

# try the verbose command
ETCDCTL_API=3 etcdctl \
  --cert /etc/kubernetes/pki/apiserver-etcd-client.crt \
  --key /etc/kubernetes/pki/apiserver-etcd-client.key \
  --cacert /etc/kubernetes/pki/etcd/ca.crt \
  member list
```

## Bring in some convenience into communication with etcd

```bash
# add ETCD env vars to .trainingrc
echo "export ETCDCTL_API=3" >> ~/.trainingrc
echo "export ETCDCTL_ENDPOINTS=https://127.0.0.1:2379" >> ~/.trainingrc
echo "export ETCDCTL_CACERT=/etc/kubernetes/pki/etcd/ca.crt" >> ~/.trainingrc
echo "export ETCDCTL_KEY=/etc/kubernetes/pki/apiserver-etcd-client.key" >> ~/.trainingrc
echo "export ETCDCTL_CERT=/etc/kubernetes/pki/apiserver-etcd-client.crt" >> ~/.trainingrc
cat ~/.trainingrc
source ~/.trainingrc
env | grep ETCD

# try communication again
etcdctl member list
```

## Get a value via etcdctl

```bash
# write a value
kubectl create cm my-cm --from-literal foo=bar

#get the value
etcdctl get /registry/configmaps/default/my-cm
```

## Backup

```bash
# create backup
etcdctl snapshot save ~/etcd-backup.db

# verify backup
etcdctl --write-out=table snapshot status ~/etcd-backup.db

# create a pod
kubectl run my-nginx --image nginx
kubectl get pods
```

## Restore

```bash
# move all static manifests
mv /etc/kubernetes/manifests/ ~/
# => kubernetes is not running now

# restore backup
mv /var/lib/etcd ~/etcd-old
etcdctl snapshot restore ~/etcd-backup.db --data-dir /var/lib/etcd/

# move all static manifests back again
mv  ~/manifests/ /etc/kubernetes/manifests/

# ensure pod `my-nginx` is NOT running
kubectl get pods
```
