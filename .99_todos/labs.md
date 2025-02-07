# decrease the attack vector

read-only pods
small images
distroless - show the pain points

# container image signing

=> needs container registry...

# verification of falco installation

systemctl status falco does not work anymore

# new lab to track syscalls before doing the linux kernel stuff

# cilium tetragon vs falco

# add lab for seccomp

# add pod stracing

# syscalls of pod

```bash
crictl ps
crictl inspect <CONTAINER_ID> | grep -C2 pid
ps aux | grep my-suboptimal-pod
strace -p <PID> -f
strace -p <PID> -f -cw
```

# install yq and make use of it in mla

Run an NSA compliance check
