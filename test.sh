#!/usr/bin/env sh
# Smoke test: scaffold a Material site and build it strictly.
set -eu
IMAGE="${1:?usage: test.sh <image:tag>}"
TMP="$(mktemp -d)"
mkdir -p "$TMP/docs"
printf '# Hello\n' > "$TMP/docs/index.md"
cat > "$TMP/mkdocs.yml" <<'YAML'
site_name: smoke-test
theme:
  name: material
plugins:
  - search
  - minify
  - awesome-pages
YAML
# --user: the image runs as uid 10001, which cannot read a 0700 mktemp dir, and
# anything it did write into the mount would be owned by 10001 and undeletable
# by the `rm -rf` below. Building as the caller fixes both.
docker run --rm --user "$(id -u):$(id -g)" -v "$TMP:/docs" "$IMAGE" build --strict
[ -f "$TMP/site/index.html" ] || { echo "FAIL: no site built" >&2; rm -rf "$TMP"; exit 1; }
rm -rf "$TMP"
echo PASS
