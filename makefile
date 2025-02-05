.PHONY: verify
verify:
	cat /var/log/cloud-init-output.log | grep "CloudInit Finished Successfully"
	containerd --version
	kubelet --version
	kubeadm version
	kubectl version
	test -n "$(IP)"
	test -n "$(API_SERVER)"
	kubectl get node $(hostname) | grep Ready
	kubectl -n kube-system get pod -l k8s-app=metrics-server | grep Running
	kubectl -n default get pod my-suboptimal-pod | grep Running
	openssl version
	kubesec version
	trivy --version
	strace --version
	apparmor_status --enabled
	runc --version
	runsc --version
	falco --version
	echo "Training Environment successfully verified"
