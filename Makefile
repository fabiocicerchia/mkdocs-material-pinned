IMAGE     ?= fabiocicerchia/mkdocs-material-pinned
# Tag mirrors the bundled mkdocs-material version.
VERSION   ?= 9.6.15
PLATFORMS ?= linux/amd64,linux/arm64

.PHONY: build lint test push release

build:
	docker build -t $(IMAGE):$(VERSION) .

lint:
	docker run --rm -i hadolint/hadolint < Dockerfile

test: build
	./test.sh $(IMAGE):$(VERSION)

push: build
	docker push $(IMAGE):$(VERSION)

release:
	docker buildx build --platform $(PLATFORMS) \
		-t $(IMAGE):$(VERSION) -t $(IMAGE):latest --push .
