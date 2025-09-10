start-all:
	$(MAKE) start CLUSTER=eks-use1
	$(MAKE) start CLUSTER=eks-usw2 
	@echo "All clusters created and bootstrapped successfully"

pause-all:
	$(MAKE) pause CLUSTER=eks-use1
	$(MAKE) pause CLUSTER=eks-usw2
	@echo "All clusters paused"

resume-all:
	$(MAKE) resume CLUSTER=eks-use1
	$(MAKE) resume CLUSTER=eks-usw2
	@echo "All clusters resumed"

stop-all:
	$(MAKE) delete CLUSTER=eks-use1
	$(MAKE) delete CLUSTER=eks-usw2
	$(MAKE) clean-devices
	@echo "All clusters deleted and devices cleaned"

start: create bootstrap
	@echo "Cluster $(CLUSTER) created and bootstrapped successfully"

bootstrap:
	kubectl apply -k clusters/common/bootstrap/flux
	kubectl apply -k clusters/$(CLUSTER)/flux/config

create:
	eksctl create cluster -f clusters/$(CLUSTER)/ekscluster.yaml

delete:
	-eksctl delete cluster -f clusters/$(CLUSTER)/ekscluster.yaml

pause:
	eksctl scale nodegroup --cluster $(CLUSTER) --nodes 0

resume:
	eksctl scale nodegroup --cluster $(CLUSTER) --nodes 2

clean-devices:
	gh repo set-default keiretsu-labs/tailscale-kubernetes-demo
	gh workflow run delete-inactive-tailnet-nodes.yml -f dry_run=false -f tags="tag:k8s"
	gh workflow run delete-inactive-tailnet-nodes.yml -f dry_run=false -f tags="tag:k8s-operator"

