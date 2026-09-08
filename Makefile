IMAGE     ?= ghcr.io/fabiocicerchia/mkdocs-material-pinned
# Tag mirrors the bundled mkdocs-material version.
VERSION   ?= 9.7.7
PLATFORMS ?= linux/amd64,linux/arm64

# Every verb this repository exposes lives here; `make` on its own prints them.
# FC-GEN-057: the same eight verbs in every repo, each either wired or a
# declared no-op that says why. None of them exit 0 quietly.

.PHONY: help setup install build test lint run format analyze push release

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

lint: ## Run the whole gate — every hook, every file
	pre-commit run --all-files

test: build ## Build, then run the smoke tests
	./test.sh $(IMAGE):$(VERSION)

setup: ## Install the pre-commit hook
	pre-commit install

install: ## Pull the published image onto this machine
	docker pull $(IMAGE):$(VERSION)

run: build ## Serve the docs in $(PWD) (ARGS is the mkdocs subcommand)
	docker run --rm -p 8000:8000 -v $(PWD):/docs $(IMAGE):$(VERSION) $(ARGS)

format: ## Rewrite what the gate can fix: whitespace, line endings, final newline
	@# A fixing hook exits 1 when it rewrites a file. That is this target doing
	@# its job, not failing, so the exits are ignored — make still prints what
	@# each hook said.
	-pre-commit run --all-files trailing-whitespace
	-pre-commit run --all-files end-of-file-fixer
	-pre-commit run --all-files mixed-line-ending

analyze: ## Scan the tree the way CI does — vulnerabilities, misconfig, secrets
	@command -v trivy >/dev/null 2>&1 || { \
		echo "analyze needs trivy: https://trivy.dev/latest/getting-started/installation/" >&2; \
		exit 69; }
	trivy fs --scanners vuln,misconfig,secret --severity CRITICAL,HIGH .

push: build ## Push the tagged image
	docker push $(IMAGE):$(VERSION)

release: ## Multi-arch buildx build and push (version + latest)
	docker buildx build --platform $(PLATFORMS) \
		-t $(IMAGE):$(VERSION) -t $(IMAGE):latest --push .
