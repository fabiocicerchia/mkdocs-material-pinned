# mkdocs-material-pinned

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

## Usage

Live-reload dev server (default command):

```sh
docker run --rm -p 8000:8000 -v "$PWD:/docs" fabiocicerchia/mkdocs-material-pinned
```

Strict CI build:

```sh
docker run --rm -v "$PWD:/docs" fabiocicerchia/mkdocs-material-pinned:9.6.15 build --strict
```

GitHub Pages deploy with mike:

```sh
docker run --rm -v "$PWD:/docs" --entrypoint mike \
  fabiocicerchia/mkdocs-material-pinned deploy --push --update-aliases 1.2 latest
```

## Tags

`<mkdocs-material version>` (e.g. `9.6.15`) and `latest`. Each tag is
immutable once published; plugin bumps produce a new Material-version tag or a
`-r2` rebuild suffix.

## Development

`make build` / `make lint` / `make test` (builds a real Material site with
plugins enabled, `--strict`) / `make release`.

## License

Apache-2.0 — see [LICENSE](LICENSE).
