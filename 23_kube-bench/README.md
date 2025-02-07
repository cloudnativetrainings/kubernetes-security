# Benchmarking via kubebench

In this lab you will learn how to use the tool kube-bench to benchmark your cluster.

```bash
# inspect the kubebench job
cat 23_kube-bench/job.yaml

# run kubebench
kubectl apply -f 23_kube-bench/job.yaml

# wait until the job has completed
kubectl get pods

# inspect the logs of kubebench
kubectl logs <KUBE_BENCH_POD>

# check the proposals of kube-bench
kubectl logs <KUBE_BENCH_POD> | grep FAIL
```
