# Static Analysis via Kubesec

In this lab you will learn how to do scans of your manifests via kubesec.

## Critical Issues

```bash
# scan the pod yaml
kubesec scan pod.yaml
```

You will get a json structure with a negative score like this:

```json
"object": "Pod/my-suboptimal-pod.default",
"valid": true,
"fileName": "pod.yaml",
"message": "Failed with a score of -37 points",
"score": -37,
"scoring": {
    "critical": [
    {
        "id": "Privileged",
        "selector": "containers[] .securityContext .privileged == true",
        "reason": "Privileged containers can allow almost completely unrestricted host access",
        "points": -30
    },
    {
        "id": "AllowPrivilegeEscalation",
        "selector": "containers[] .securityContext .allowPrivilegeEscalation == true",
        "reason": "",
        "points": -7
    }
    ],
```

Fix the critical issues. Afterwards run the scan again. You will get a score of zero.

## Advisory Issues

Fix some issues, eg

- Do not run as root user
- Enable resource requests and limits
- Mount the host volume as read only

Afterwards run the scan again. You will get a positive score.

```bash
# Apply the changes
kubectl apply -f pod.yaml --force
```

## Run kubesec via kubectl plugin

```bash
# install kubesec-scan kubectl plugin
kubectl krew search kubesec-scan
kubectl krew install kubesec-scan

# investigate krew mechanisms
ls -alh ~/.krew/bin/
kubectl krew list
kubectl plugin list
cat ~/.krew/receipts/kubesec-scan.yaml

# scan running pod, note that now the running pod gets scanned
kubectl kubesec-scan pod my-suboptimal-pod
```
