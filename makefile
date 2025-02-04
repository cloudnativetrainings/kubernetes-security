.PHONY: debug-installation
debug-installation:
	gcloud compute scp root@kubernetes-security:/var/log/cloud-init-output.log .

.PHONY: verify
verify:
	containerd --version
	kubelet --version
	kubeadm version
	kubectl version
	test -n "$(IP)"
	test -n "$(API_SERVER)"
# TODO kubectl get node kubernetes-security | grep Ready
	kubectl -n kube-system get pod -l k8s-app=metrics-server | grep Running
# TODO check lshttpd
# check pod and rbac from patch k8s
# check openssl

# check if kubesec is installed on host level
kubesec version

# Verify installation
trivy --version

strace --version
apparmor
gvisor
systemctl status falco-modern-bpf.service


	echo "Training Environment successfully verified"
