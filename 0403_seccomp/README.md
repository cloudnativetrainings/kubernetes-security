# Host Level Security with Seccomp

## Install

### Enable seccomp in kubelet

```bash
# /var/lib/kubelet/config
seccompDefault: true

systemctl restart kubelet
systemctl status kubelet
```

### Create custom profile

```bash
cat 0403_seccomp/my-profile.json

mkdir -p /var/lib/kubelet/seccomp/profiles
cp 0403_seccomp/my-profile.json /var/lib/kubelet/seccomp/profiles/
```

## Verify Pod is allowed to write files

```bash
kubectl exec my-suboptimal-pod -- touch /tmp/some.file.again
kubectl exec -it my-suboptimal-pod -- ls -alh /tmp
```

## Verify seccomp is working

### Enable profile

```yaml
---
spec:
  securityContext:
    seccompProfile:
      type: Localhost
      localhostProfile: profiles/my-profile.json
```

```bash
kubectl apply -f pod.yaml --force
```

## Verify

```bash
crictl ps | grep my-sub
crictl inspect <CONTAINER_ID> | grep -C5 seccomp

kubectl exec -it my-suboptimal-pod -- touch some.file.again
# => error message


#  TODO does not work

```

## Teardown

```bash
# uncomment seccomp in pod
kubectl apply -f pod.yaml
```
