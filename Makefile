bootstrap:
	kubectl apply -k clusters/common/bootstrap/flux
	kubectl apply -k clusters/$(CLUSTER)/flux/config

create:
	eksctl create cluster -f clusters/$(CLUSTER)/ekscluster.yaml

delete:
	eksctl delete cluster -f clusters/$(CLUSTER)/ekscluster.yaml