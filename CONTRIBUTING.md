# Contributing

Thanks for taking the time to contribute!

## Getting started

1. Fork and clone the repo.
2. Install pre-commit hooks: `pre-commit install` (see `.pre-commit-config.yaml`).
3. Create a branch: `git checkout -b feat/short-description`.

## Making changes

- Keep changes focused; one logical change per PR.
- Update `docs/` and `examples/` when behavior changes.
- Ensure CI (`code-quality` + `security`) passes.

Keep `CHANGELOG.md` up to date by hand — note the mkdocs-material version
each entry ships (see [Releases](#releases)).

## Commit messages

Use [Conventional Commits](https://www.conventionalcommits.org/): `feat:`,
`fix:`, `docs:`, `chore:`, etc. They keep history readable. They do **not**
drive the version here — the mkdocs-material pin does.

## Releases

The image tag is the bundled mkdocs-material version, so the pin is the
release — there is no separate semver for this repo.

1. Bump `mkdocs-material==` in `requirements.txt` on `main`.
2. [publish.yml](.github/workflows/publish.yml) reads that pin, builds,
   smoke-tests, and pushes `ghcr.io/fabiocicerchia/mkdocs-material-pinned`
   tagged with the pin and `latest`.
3. A rebuild with no pin change is a manual `workflow_dispatch` run.

Changes that don't touch `requirements.txt` or the `Dockerfile` don't publish
anything — there is nothing new to ship.

## Pull requests

Fill out the PR template, link related issues, and request review. Be kind.
