# CLAUDE.md

Guidance for Claude Code (and other AI agents) working in this repo.

## Project

MkDocs + Material + the plugins everyone actually uses, **fully
version-pinned** for reproducible docs builds. The image tag mirrors the bundled
`mkdocs-material` version, so a docs pipeline never breaks because a transitive
plugin moved overnight.

## Commands

```sh
make help         # every verb this repo exposes
make build        # Build the image locally
make lint         # Lint the Dockerfile
make test         # Build, then run the smoke tests
make push         # Push the tagged image
make release      # Multi-arch buildx build and push (version + latest)
```

## Tooling

Shared config — the GitHub workflows, `.pre-commit-config.yaml`,
`.editorconfig`, `.hadolint.yaml`, `SECURITY.md` — comes from
[repo-skeleton](https://github.com/fabiocicerchia/repo-skeleton). Edit it
there, not here; a local edit is drift and the next sync overwrites it.
`check-drift.sh` in that repo reports what has diverged.

- `make setup` installs the pre-commit hook, and that is the whole of it.
  Don't add a `.githooks/` directory: `core.hooksPath` replaces `.git/hooks/`
  wholesale, so setting it silently stops every pre-commit hook from running.
- Hooks are pinned by commit SHA with the tag in a trailing comment. A tag can
  be moved, a SHA cannot.
- CI runs this same `.pre-commit-config.yaml` through `pre-commit/action`, so
  what passes locally is what gates the pull request.

## Conventions

- Match existing style; don't reformat unrelated code.
- Conventional Commits for messages (see CONTRIBUTING.md). They do not drive
  the version: the `mkdocs-material==` pin in `requirements.txt` is the version.
- `CHANGELOG.md` is maintained by hand.
- Update `docs/` and `examples/` with behavior changes.
- Never commit secrets; CI runs gitleaks. Keep `.env` out of git.

## Guardrails

- Pin every version and leave a `# VERSION-BUMP` comment beside it.
- `test.sh` runs against the built image — a new capability needs a case there.
- The image tag must always equal the bundled mkdocs-material version.
- Adding a plugin means pinning it *and* its transitive deps.
- Don't touch generated files or lockfiles by hand.
- Ask before large refactors or destructive operations.
