# Getting Started

## Prerequisites

Docker, and a directory containing `mkdocs.yml`. Nothing else — no Python
environment, no plugin installs.

## Preview while you write

```sh
docker run --rm -p 8000:8000 -v "$PWD:/docs" \
  fabiocicerchia/mkdocs-material-pinned
```

Open <http://localhost:8000>. That is the default command — `mkdocs serve`
bound to `0.0.0.0`, which is what makes it reachable from outside the
container. Live reload works through the bind mount.

## Build it the way CI will

```sh
docker run --rm --user "$(id -u):$(id -g)" -v "$PWD:/docs" \
  fabiocicerchia/mkdocs-material-pinned:9.6.15 build --strict
```

Three deliberate differences from the preview command:

**It runs as you.** The image runs as uid 10001. `serve` only reads the mount,
but `build` writes `site/` back into it — without `--user` that output is owned
by uid 10001 and your next `rm -rf site` fails.

**The tag is pinned.** `9.6.15` is the bundled `mkdocs-material` version — that
is what the tag means here. `latest` is for previewing; a docs build that can
change under you is the thing this image exists to prevent.

**`--strict`.** Warnings become errors: a broken internal link, a page missing
from `nav`, a plugin that failed to load. Without it those pass silently and
ship.

The site lands in `site/`, owned by uid 10001. If the build fails at the very
end with a permission error, that is the mounted directory not being writable
by that uid.

## In CI

```yaml
jobs:
  docs:
    runs-on: ubuntu-latest
    container: fabiocicerchia/mkdocs-material-pinned:9.6.15
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0     # git-revision-date-localized needs real history
      - run: mkdocs build --strict
```

`fetch-depth: 0` is not optional if you use the "last updated" line. A shallow
checkout has no commit dates for most files, and the plugin quietly falls back
to the epoch — pages dated 1 January 1970 with no error anywhere.

## Versioned docs with `mike`

`mike` is bundled, but it is not `mkdocs`, so the entrypoint has to be
overridden:

```sh
docker run --rm --user "$(id -u):$(id -g)" -v "$PWD:/docs" --entrypoint mike \
  fabiocicerchia/mkdocs-material-pinned \
  deploy --push --update-aliases 1.2 latest
```

This commits the built site to the `gh-pages` branch and pushes, so it needs
git credentials in the container and a non-shallow checkout. Set the alias once:

```sh
docker run --rm --user "$(id -u):$(id -g)" -v "$PWD:/docs" --entrypoint mike \
  fabiocicerchia/mkdocs-material-pinned set-default latest
```

## What is bundled

Everything in [`requirements.txt`](https://github.com/fabiocicerchia/mkdocs-material-pinned/blob/main/requirements.txt),
pinned exactly: `mkdocs`, `mkdocs-material` and its extensions,
`pymdown-extensions`, minify, redirects, awesome-pages,
git-revision-date-localized, and `mike`.

Enable them in your own `mkdocs.yml` as usual:

```yaml
theme:
  name: material
plugins:
  - search
  - minify
  - awesome-pages
  - git-revision-date-localized
markdown_extensions:
  - admonition
  - pymdownx.superfences
```

Nothing is enabled for you. The image provides the versions; the config is
yours.

## Choosing a tag

| Tag | Use it for |
|---|---|
| `9.6.15` | CI, and anything reproducible. Immutable once published. |
| `latest` | Local previewing only. |
| `9.6.15-r2` | Same Material, rebuilt with different plugin pins. |

## Development

```sh
make build     # docker build
make lint      # hadolint
make test      # scaffolds a real Material site with plugins, builds --strict
make release   # multi-arch buildx push
```

`make test` is the check that matters when bumping a pin: it builds a site with
the plugins actually enabled, under `--strict`, so a plugin that installs but
no longer loads fails the test rather than shipping.
