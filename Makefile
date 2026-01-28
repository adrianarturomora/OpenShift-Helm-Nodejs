APP_IMAGE ?= openshift-helm-nodejs:local

.PHONY: run build helm-lint helm-template

run:
	cd app && npm ci && npm start

build:
	docker build -t $(APP_IMAGE) .

helm-lint:
	helm lint helm/openshift-helm-nodejs

helm-template:
	helm template openshift-helm-nodejs helm/openshift-helm-nodejs
