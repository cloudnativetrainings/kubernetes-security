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
	kubectl get node kubernetes-security | grep Ready
	kubectl -n kube-system get pod -l k8s-app=metrics-server | grep Running
# TODO check lshttpd
	echo "Training Environment successfully verified"

.PHONY: get-external-ip
get-external-ip:
	gcloud compute instances describe kubernetes-security \
		--format='get(networkInterfaces[0].accessConfigs[0].natIP)' \
		--zone europe-west3-a

.PHONY: teardown
teardown:
	gcloud compute instances delete kubernetes-security --zone europe-west3-a --quiet
	gcloud compute firewall-rules delete you-are-welcome --quiet
