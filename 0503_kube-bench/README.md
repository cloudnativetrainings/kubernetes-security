# Benchmarking via kubebench

```bash
# inspect the kubebench job
cat 0503_kube-bench/job.yaml

# run kubebench
kubectl apply -f 0503_kube-bench/job.yaml

# inspect the logs of kubebench
kubectl logs <KUBE_BENCH_POD>

# check 4.2.1 and 4.2.2
kubectl logs <KUBE_BENCH_POD> | grep FAIL
```
