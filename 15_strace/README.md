# Strace

In this lab you will learn how to trace syscalls.

## Installation

```bash

# strace an echo command
strace echo "foo"
strace -cw echo "foo"

# syscalls of kill command
sleep 1m &
strace kill -9 <PID>>
strace kill -9 <PID>> 2>&1 | grep <PID>

# syscalls of kube-apiserver => PID is the first column
ps aux | grep kube-apiserver
strace -p <PID> -f
strace -p <PID> -f -cw
```
