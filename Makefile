VERSION=$(shell git log -1 --format=%h)

all: build

version:
	@echo "const ver = '$(VERSION)'"  > version.js
	@echo "module.exports = { ver }" >> version.js
	@sed -e "s/PACKAGE_VERSION/$(VERSION)/g" helm/_Chart.yaml > helm/Chart.yaml
	@sed -e "s/PACKAGE_VERSION/$(VERSION)/g" helm/_values.yaml > helm/values.yaml

build:	version
	npm install

clobber:
	podman rmi vnra:$(VERSION)
	rm -fr node_modules

run:
	npm run start

package:	build
	npm ci --only=production
	podman build --squash -t vnra:$(VERSION) .
	podman tag vnra:$(VERSION) vnra:latest
	@echo 'podman rmi $$(podman images -a | grep none | awk '{print \$$3}')'

docker-run:
	podman run -it --rm -p 8080:8080 --name vnra vnra:$(VERSION)

registry-push:	package
	podman push --tls-verify=false vnra:${VERSION} devhost:5000/foo/vnra:${VERSION}

helm-lint:	version
	helm lint --debug -f helm/prod.yaml helm
	helm lint --debug -f helm/dev.yaml  helm

helm-install-dry-run:	version
	helm install --dry-run --debug -f helm/dev.yaml vnra helm
	helm install --dry-run --debug -f helm/prod.yaml vnra helm

helm-install-dev:	helm-lint 
	helm install --debug -f helm/dev.yaml vnra helm
	
