# mkdocs-material-pinned

[![CI](https://github.com/fabiocicerchia/mkdocs-material-pinned/actions/workflows/ci.yml/badge.svg)](https://github.com/fabiocicerchia/mkdocs-material-pinned/actions/workflows/ci.yml)
[![Code Quality](https://github.com/fabiocicerchia/mkdocs-material-pinned/actions/workflows/code-quality.yml/badge.svg)](https://github.com/fabiocicerchia/mkdocs-material-pinned/actions/workflows/code-quality.yml)
[![Security](https://github.com/fabiocicerchia/mkdocs-material-pinned/actions/workflows/security.yml/badge.svg)](https://github.com/fabiocicerchia/mkdocs-material-pinned/actions/workflows/security.yml)
[![License](https://img.shields.io/badge/license-Apache_2.0-blue.svg)](LICENSE)
[![OpenSSF Scorecard](https://api.securityscorecards.dev/projects/github.com/fabiocicerchia/mkdocs-material-pinned/badge)](https://securityscorecards.dev/viewer/?uri=github.com/fabiocicerchia/mkdocs-material-pinned)
[![CI carbon](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/fabiocicerchia/mkdocs-material-pinned/gh-pages/badge.json)](.github/workflows/carbon-badge.yml)

MkDocs + Material theme + the plugins everyone actually uses, **fully
version-pinned** for reproducible docs builds. The image tag mirrors the
bundled `mkdocs-material` version, so your docs pipeline never breaks because
a transitive plugin moved overnight.

## What's inside

Pinned in [`requirements.txt`](requirements.txt):

- `mkdocs` + `mkdocs-material` (+ extensions, pymdown)
- `mkdocs-minify-plugin`, `mkdocs-redirects`, `mkdocs-awesome-pages-plugin`
- `mkdocs-git-revision-date-localized-plugin` (git included in the image)
- `mike` for versioned docs deployments

## Install

```sh
make build                       # builds ghcr.io/fabiocicerchia/mkdocs-material-pinned:9.7.7 locally
docker pull ghcr.io/fabiocicerchia/mkdocs-material-pinned:9.7.7
```

## Usage

Live-reload dev server (default command):

```sh
docker run --rm -p 8000:8000 -v "$PWD:/docs" ghcr.io/fabiocicerchia/mkdocs-material-pinned
```

Strict CI build:

```sh
docker run --rm --user "$(id -u):$(id -g)" -v "$PWD:/docs" \
  ghcr.io/fabiocicerchia/mkdocs-material-pinned:9.7.7 build --strict
```

GitHub Pages deploy with mike:

```sh
docker run --rm --user "$(id -u):$(id -g)" -v "$PWD:/docs" --entrypoint mike \
  ghcr.io/fabiocicerchia/mkdocs-material-pinned deploy --push --update-aliases 1.2 latest
```

The image runs as uid 10001, so any command that writes back into the mount
needs `--user` — otherwise `site/` comes out owned by a user you are not.

## Tags

`<mkdocs-material version>` (e.g. `9.7.7`) and `latest`. The tag is read
straight from the `mkdocs-material==` pin in `requirements.txt`, so it cannot
disagree with what is inside the image. Bumping that pin on `main` publishes
the new version.

## Development

`make build` / `make lint` / `make test` (builds a real Material site with
plugins enabled, `--strict`) / `make release`.

## Documentation

Full docs live in [`docs/`](docs/). Runnable examples live in [`examples/`](examples/).

## License

Apache-2.0 — see [LICENSE](LICENSE).
