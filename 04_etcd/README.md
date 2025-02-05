# Communication with etcd

In this lab you will learn how to communicate with the etcd db and how to backup and restore it.

```bash
# verify etcdctl is installed
etcdctl version

# verify etcdctl can communicate via etcd cluster
etcdctl member list
```

Note that communication is possible because of environment variables

```bash
# show ETCD environment variables
env | grep ETCD

# if those are not set you have to communicate like this with the etcd cluster
ETCDCTL_API=3 etcdctl \
 --cert /etc/kubernetes/pki/apiserver-etcd-client.crt \
 --key /etc/kubernetes/pki/apiserver-etcd-client.key \
 --cacert /etc/kubernetes/pki/etcd/ca.crt \
 member list

# you can get the values of those environment variables for example like this
cat /etc/kubernetes/manifests/kube-apiserver.yaml | grep etcd
```

## Get a value via etcdctl

```bash
# write a value
kubectl create cm my-cm --from-literal foo=bar

# get the value
etcdctl get /registry/configmaps/default/my-cm
```

## Backup

```bash
# create backup
etcdctl snapshot save ./etcd-backup.db

# verify backup
etcdctl --write-out=table snapshot status ./etcd-backup.db

# create a pod
kubectl run my-nginx --image nginx

# verify pod is running
kubectl get pods
```

## Restore

```bash
# move all static manifests
mkdir -p ./tmp/manifests/
mv /etc/kubernetes/manifests/* ./tmp/manifests/
# => kubernetes is not running now

# move the old etcd data to some different directory
mkdir -p ./tmp/etcd-old/
mv /var/lib/etcd ./tmp/etcd-old

# restore backup
etcdctl snapshot restore ./etcd-backup.db --data-dir /var/lib/etcd/

# move all static manifests back again
mv  ./tmp/manifests/* /etc/kubernetes/manifests/

# ensure pod `my-nginx` is NOT running, due to it was created after the db got backuped
kubectl get pods
```
