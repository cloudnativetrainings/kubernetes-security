# Host Level Security with AppArmor

In this lab you will learn how to use apparmor to limit the permissions of a container on host level.

## Verify Pod is allowed to write files

```bash
kubectl exec my-suboptimal-pod -- touch /tmp/some.file
kubectl exec -it my-suboptimal-pod -- ls -alh /tmp
```

## Engage AppArmor

### Add AppArmor Profile

```bash
# verify the profile is not engaged yet
aa-status | grep my-apparmor-profile

# inspect the apparmor profile
cat 16_apparmor/my-apparmor-profile

# copy the profile into the apparmor default profiles directory
cp 16_apparmor/my-apparmor-profile /etc/apparmor.d/

# restart apparmor
systemctl restart apparmor

# verify new profile got added
aa-status | grep my-apparmor-profile
```

### Engage Profile in Pod

Enable the apparmor annotation in the file `pod.yaml`

```yaml
---
metadata:
  name: my-suboptimal-pod
  # annotations:
  #   container.apparmor.security.beta.kubernetes.io/my-ubuntu: localhost/my-apparmor-profile
spec:
  securityContext: # <= uncomment this line on k8s > v1.31
    appArmorProfile: # <= uncomment this line on k8s > v1.31
      type: Localhost # <= uncomment this line on k8s > v1.31
      localhostProfile: my-apparmor-profile # <= uncomment this line on k8s > v1.31
```

```bash
# re-apply the pod
kubectl apply -f pod.yaml --force

# try to write the file again - you should get an error
kubectl exec my-suboptimal-pod -- touch /tmp/some.file
```

## Teardown

```bash
# uncomment apparmor profile in pod
kubectl apply -f pod.yaml --force
```
