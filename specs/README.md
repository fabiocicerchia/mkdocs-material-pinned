# Specifications of mkdocs-material-pinned

What this code does, one atomic Gherkin scenario per behaviour, read from the code by code-atlas.
Tags: `@verified` a test asserts it · `@inferred` read from the code only · `@gap` an entry point no test covers · `@human` written or amended by a person, never rewritten.

## Developer tooling
The contributor workflow for keeping the repo healthy.

- **Command catalogue**: [Discovering and running the maintenance verbs](developer-tooling/command-catalogue/make-verbs.feature) (2)

## Distribution
Getting the image built and into users' hands.

- **Kubernetes chart**: [Validating the Helm chart](distribution/kubernetes-chart/chart-validation.feature) (2)
- **Local build**: [Running the docs image against the current folder](distribution/local-build/local-docs-run.feature) (2)

## Docs site
What a user gets from running the image against their documentation.

- **Live preview**: [Previewing and building docs with the image](docs-site/live-preview/docs-container-defaults.feature) (3)

## Reproducibility
Guarantees that the same image tag always produces the same docs toolchain.

- **Dependency lock**: [Refusing to build from a stale lockfile](reproducibility/dependency-lock/dependency-lock-guard.feature) (3)
- **Version tagging**: [Tagging and releasing the image by its mkdocs-material version](reproducibility/version-tagging/image-version-tagging.feature) (3)

## Security
How the image limits risk for the people who run and publish it.

- **Non-root runtime**: [Running the docs container without root](security/non-root-runtime/non-root-container.feature) (1)
- **Security scanning**: [Scanning the tree the way CI does](security/security-scanning/local-security-scan.feature) (2)
- **Supply-chain integrity**: [Refusing tampered or drifting image inputs](security/supply-chain-integrity/tamper-resistant-image-build.feature) (2)

## User experience
How the image behaves and communicates when used by hand or in pipelines.

- **Image metadata**: [Describing the image to registries and users](user-experience/image-metadata/image-metadata.feature) (2)
