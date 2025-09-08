bootstrap:
	kubectl apply -k clusters/common/bootstrap/flux
	kubectl apply -k clusters/$(CLUSTER)/flux/config