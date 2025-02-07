# Runtime Security with Falco

In this lab you will learn how to log users connecting to containers.

## Configure Falco

Edit the Falco configuration file

```bash
vi /etc/falco/falco.yaml
```

Configure the `file_output` section to the following.

```yaml
file_output:
  enabled: true
  keep_alive: false
  filename: /var/log/falco.log
```

## Verify logging

```bash
# verify no logs
cat /var/log/falco.log

# exec into the pod
kubectl exec -it my-suboptimal-pod -- bash
exit

# verify that a line like this got logged
cat /var/log/falco.log
```

## Configure Rules

```bash
# check falco dir
ls -alh /etc/falco

# find rule called "Terminal shell in container"
vi /etc/falco/falco_rules.yaml

# copy rule into the following file and change the priority from NOTICE towards WARNING
vi /etc/falco/falco_rules.local.yaml

# exec into the pod
kubectl exec -it my-suboptimal-pod -- bash
exit

# verify that a line like this got logged
cat /var/log/falco.log
```
