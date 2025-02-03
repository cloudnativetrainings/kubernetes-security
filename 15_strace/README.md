# Strace

## Installation

```bash
# install
apt-get install strace
strace --version

# strace something
strace echo "foo"
strace -cw echo "foo"

# syscalls of kill command
strace kill -9 1234 2>&1 | grep 1234

# syscalls of kube-apiserver => PID is the first column
ps aux | grep kube-apiserver
strace -p <PID> -f 
strace -p <PID> -f -cw

# syscalls of pod
kubectl run my-pod -it --image=ubuntu --restart=Never --rm -- /bin/bash
# switch to another terminal
kubectl get pods
ps aux | grep my-pod
strace -p <PID> -f 
strace -p <PID> -f -cw
```
