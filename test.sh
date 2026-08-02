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
docker run --rm -v "$TMP:/docs" "$IMAGE" build --strict
[ -f "$TMP/site/index.html" ] || { echo "FAIL: no site built" >&2; rm -rf "$TMP"; exit 1; }
rm -rf "$TMP"
echo PASS
