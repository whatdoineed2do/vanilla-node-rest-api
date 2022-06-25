all:
	npm install
	npm ci --only=production

clobber:
	podman rmi vanilla-node-rest-api
	rm -fr node_modules

run:
	npm run start

package:
	podman build --squash -t vanilla-node-rest-api:0.0.1 .
	@echo "podman rmi \$(podman images -a | grep none | awk '{print $3}')"

docker-run:
	podman run -it --rm -p 8080:5000 --name vnra vanilla-node-rest-api

