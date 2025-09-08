start-all:
	$(MAKE) start CLUSTER=eks-use1
	$(MAKE) start CLUSTER=eks-usw2
	@echo "All clusters created and bootstrapped successfully"

stop-all:
	$(MAKE) stop CLUSTER=eks-use1
	$(MAKE) stop CLUSTER=eks-usw2
	@echo "All clusters deleted and devices cleaned"

start: create bootstrap
	@echo "Cluster $(CLUSTER) created and bootstrapped successfully"

stop: delete clean-devices
	@echo "Cluster $(CLUSTER) deleted and devices cleaned"

bootstrap:
	kubectl apply -k clusters/common/bootstrap/flux
	kubectl apply -k clusters/$(CLUSTER)/flux/config

create:
	eksctl create cluster -f clusters/$(CLUSTER)/ekscluster.yaml

delete:
	-eksctl delete cluster -f clusters/$(CLUSTER)/ekscluster.yaml

clean-devices:
	gh repo set-default rajsinghtech/tailscale-kubernetes-demo
	gh workflow run delete-inactive-tailnet-nodes.yml -f dry_run=false

