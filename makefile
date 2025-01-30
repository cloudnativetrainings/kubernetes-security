
.PHONY: setup
setup:
	gcloud compute firewall-rules create you-are-welcome \
		--direction=INGRESS --priority=1000 --network=default \
		--action=ALLOW --rules=all --source-ranges=0.0.0.0/0
	gcloud compute instances create kubernetes-security \
		--zone=europe-west3-a \
		--machine-type=n2-standard-4 \
		--image-family=ubuntu-2204-lts \
		--image-project=ubuntu-os-cloud \
		--boot-disk-size=250GB \
		--metadata-from-file user-data=cloudinit.yaml

.PHONY: debug-installation
debug-installation:
	gcloud compute scp root@kubernetes-security:/var/log/cloud-init-output.log .

.PHONY: connect
connect:
	gcloud compute ssh root@kubernetes-security --zone=europe-west3-a

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
