VERSION=$(shell git log -1 --format=%h)

all: build

version:
	@echo "const ver = '$(VERSION)'"  > src/version.js
	@echo "module.exports = { ver }" >> src/version.js
	@sed -e "s/PACKAGE_VERSION/$(VERSION)/g" openshift/helm/_Chart.yaml > openshift/helm/Chart.yaml
	@sed -e "s/PACKAGE_VERSION/$(VERSION)/g" openshift/helm/_values.yaml > openshift/helm/values.yaml

build:	version
	cd src ; npm install

clobber:
	podman rmi vnra:$(VERSION)
	rm -fr src/node_modules

run:	version
	cd src; npm run start

package:	build
	cd src ; npm ci --only=production
	podman build --squash -t vnra:$(VERSION) .
	podman tag vnra:$(VERSION) vnra:latest
	@echo 'podman rmi $$(podman images -a | grep none | awk '{print \$$3}')'

docker-run:
	podman run -it --rm -p 8080:8080 --name vnra vnra:$(VERSION)

registry-push:	package
	podman push --tls-verify=false vnra:${VERSION} devhost:5000/foo/vnra:${VERSION}

helm-lint:	version
	helm lint --debug -f openshift/helm/prod.yaml helm
	helm lint --debug -f openshift/helm/dev.yaml  helm

helm-install-dry-run:	version
	helm install --dry-run --debug -f openshift/helm/dev.yaml vnra helm
	helm install --dry-run --debug -f openshift/helm/prod.yaml vnra helm

helm-install-dev:	helm-lint 
	helm install --debug -f openshift/helm/dev.yaml vnra helm
	
