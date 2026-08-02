# Basic Example

What it shows: a real Material site that exercises the bundled plugins, built
strictly — so "the image works" means the plugins loaded, not just that mkdocs
exited 0.

## Preview it

```sh
docker run --rm -p 8000:8000 -v "$PWD:/docs" \
  fabiocicerchia/mkdocs-material-pinned
```

Open <http://localhost:8000>. Edit `docs/index.md` and the page reloads.

## Build it the way CI would

```sh
docker run --rm -v "$PWD:/docs" \
  fabiocicerchia/mkdocs-material-pinned:9.6.15 build --strict
```

```text
INFO    -  Cleaning site directory
INFO    -  Building documentation to directory: /docs/site
INFO    -  Documentation built in 0.62 seconds
```

`--strict` is what makes this an assertion. Try breaking it:

```sh
echo '[a broken link](does-not-exist.md)' >> docs/index.md
docker run --rm -v "$PWD:/docs" \
  fabiocicerchia/mkdocs-material-pinned:9.6.15 build --strict ; echo "exit=$?"
```

```text
ERROR   -  Doc file 'index.md' contains a link 'does-not-exist.md', but the
           target is not found among documentation files.
Aborted with 1 warnings in strict mode!
exit=1
```

Without `--strict` that is a warning nobody reads, and the broken link ships.

## See the shallow-checkout trap

`git-revision-date-localized` reads commit dates. In a repository with no
history for the file, it falls back to the epoch — silently:

```sh
docker run --rm -v "$PWD:/docs" \
  fabiocicerchia/mkdocs-material-pinned:9.6.15 build --strict
grep -o 'January 1, 1970' site/index.html && echo "<-- shallow history"
```

In GitHub Actions the fix is `fetch-depth: 0` on the checkout step. There is no
error to catch here, which is why it is worth knowing before someone notices
every page claims to be from 1970.

## Clean up

```sh
rm -rf site
git checkout -- docs/index.md    # if you added the broken link
```
