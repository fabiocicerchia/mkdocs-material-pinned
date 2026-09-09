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

# ...and without --user it has to say why. mkdocs' own PermissionError names
# neither the uid nor the fix, which is the whole reason the entrypoint exists.
# Skipped as root, which can write into the mount and so never hits the case.
if [ "$(id -u)" -ne 0 ]; then
  out="$(docker run --rm -v "$TMP:/docs" "$IMAGE" build --strict 2>&1 || true)"
  case "$out" in
    *--user*) ;;
    *) echo "FAIL: unwritable mount gave no hint:" >&2; echo "$out" >&2; rm -rf "$TMP"; exit 1 ;;
  esac
fi

rm -rf "$TMP"
echo PASS
