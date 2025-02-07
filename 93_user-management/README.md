# User Management

In this lab you will learn how to manualy manage users.

## Create a CertificateSigningRequest via openssl

```bash
openssl genrsa -out john.key 2048
openssl req -new -key john.key -out john.csr
cat john.csr | base64 -w 0
```

## Create the CertificateSigningRequest in Kubernetes

Create the following file and make use of the CSR from the first step in the field `request`.

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
kubectl auth can-i list pods --as john # => yes
kubectl auth can-i delete pods --as john # => no
kubectl -n kube-system auth can-i list pods --as john # => no
```
