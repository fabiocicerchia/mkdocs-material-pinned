IMAGE     ?= ghcr.io/fabiocicerchia/mkdocs-material-pinned
# Tag mirrors the bundled mkdocs-material version.
VERSION   ?= 9.7.7
PLATFORMS ?= linux/amd64,linux/arm64

.PHONY: build lint test push release lock lock-check help

.DEFAULT_GOAL := help

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
	  awk 'BEGIN {FS = ":.*?## "}; {printf "  %-10s %s\n", $$1, $$2}'

build: lock-check ## Build the image locally
	docker build -t $(IMAGE):$(VERSION) .

# requirements.txt stays the human list of pins; requirements.lock is that
# list resolved, with its transitive tree and a hash per artifact.
lock: ## Regenerate requirements.lock from requirements.txt
	uv pip compile requirements.txt --generate-hashes --universal -p 3.14 -o requirements.lock

lock-check: ## Fail if a pin in requirements.txt is missing from requirements.lock
	@missing="$$(grep -vE '^[[:space:]]*(#|$$)' requirements.txt | tr -d ' ' | \
	  while read -r pin; do grep -qiE "^$$pin \\\\$$" requirements.lock || echo "$$pin"; done)"; \
	[ -z "$$missing" ] || { echo "requirements.lock is stale, missing: $$missing"; echo 'run: make lock'; exit 1; }

lint: ## Lint the Dockerfile
	docker run --rm -i hadolint/hadolint < Dockerfile

test: build ## Build, then run the smoke tests
	./test.sh $(IMAGE):$(VERSION)

push: build ## Push the tagged image
	docker push $(IMAGE):$(VERSION)

release: ## Multi-arch buildx build and push (version + latest)
	docker buildx build --platform $(PLATFORMS) \
		-t $(IMAGE):$(VERSION) -t $(IMAGE):latest --push .
