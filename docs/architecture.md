# Architecture

There is barely any code here, and that is the design. The repository's real
content is `requirements.txt`.

```
python:3.13-slim-bookworm
  └── apt: git            (git-revision-date-localized, mike)
  └── pip install -r requirements.txt     ← every version pinned, no ranges
  └── USER 10001, WORKDIR /docs
  └── ENTRYPOINT ["mkdocs"]
      CMD ["serve", "--dev-addr=0.0.0.0:8000"]
```

## The pin is the product

A docs pipeline that says `pip install mkdocs-material` builds a different site
every time it runs. That is fine until the morning a transitive plugin moves,
`--strict` starts failing on a warning that did not exist yesterday, and the
docs build blocks a release for a reason nobody changed.

So `requirements.txt` has no ranges — `==` on all nine packages, including the
extension and pymdown packages that are usually left to resolve themselves.
Those are exactly the ones that move underneath you.

`pip install` at build time, not runtime: the layer is the lock. There is no
resolution step when the container starts, which is also why it works in a
network-restricted runner.

## The tag mirrors `mkdocs-material`

The image tag is the bundled Material version — `9.6.15`, not `0.1.0`. A docs
image whose tag does not tell you which Material you get is a tag you have to
look up, every time.

Consequences worth knowing:

- **Tags are immutable once published.** A rebuild with different plugin
  versions is a new tag, not a re-push.
- **A plugin-only bump has no Material version to move to.** It gets a `-r2`
  suffix on the same Material version.
- **`latest` moves.** Use it for local previewing, never in CI.

This is also why a dependabot PR against `requirements.txt` is a release, not a
chore: the pinned set *is* what is shipped.

## `git` is not incidental

Two of the bundled plugins need a real git repository at build time:
`git-revision-date-localized` reads commit timestamps for the "last updated"
line, and `mike` commits the built site to `gh-pages`.

Both fail in ways that point at the wrong thing when git is missing or the
checkout is shallow — a page dated 1970, or a `mike deploy` that cannot find
the branch. That is why `git` is installed in the image, and why CI checkouts
for docs need `fetch-depth: 0`.

## Non-root, and what it means for `mike`

The image runs as uid 10001 with `/docs` as the working directory. `mkdocs
build` writes `site/` into the mounted directory, so that directory has to be
writable by that uid — the usual symptom of getting it wrong is a permission
error at the very end of an otherwise successful build.

`mike deploy --push` additionally needs git credentials and write access to
`.git`, which is why the `mike` examples override the entrypoint rather than
running through `mkdocs`.

## Why `ENTRYPOINT ["mkdocs"]`

So the container *is* the mkdocs command: `docker run ... build --strict`
reads as `mkdocs build --strict`. The default `CMD` binds the dev server to
`0.0.0.0` rather than localhost, because a server bound to localhost inside a
container is reachable from nowhere.

Anything that is not mkdocs — `mike`, a shell — needs `--entrypoint`.

## Changing the bundled set

1. Add or bump the pin in `requirements.txt`. Exact versions only.
2. If the plugin needs a system package, add it to the `apt-get` line — the
   `git` precedent, not a new pattern.
3. `make test` builds a real Material site with the plugins enabled under
   `--strict`. That is the whole safety net: `--strict` turns a plugin that
   loaded but did nothing into a failure, which is the failure mode a
   smoke test that only checks "did it exit 0" would miss.
4. New Material version → new tag. Plugin-only change → `-r2` on the current
   one.

The bar for adding a plugin is that it is one people reach for immediately, not
one they might. Every addition is a version that can move and break somebody's
build.
