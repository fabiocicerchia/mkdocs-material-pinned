#!/usr/bin/env sh
# mkdocs, plus one line of explanation when the build cannot write its output.
#
# The image runs as uid 10001, on purpose. A bind-mounted checkout keeps its
# host ownership, so `build` cannot create ./site and mkdocs exits with a bare
# `PermissionError: [Errno 13] Permission denied: '/docs/site'` — which names
# neither the uid it ran as nor the flag that fixes it. That is a five-minute
# detour for everyone who mounts their docs the obvious way.
#
# The check runs *after* the failure, not before it: `site_dir` can point
# anywhere, so an unwritable working directory is not on its own a reason to
# refuse. And it deliberately does not fall back to a writable path — a
# `--strict` build that exits 0 having written the site somewhere the caller
# cannot see is worse than one that fails.
set -u

case "${1:-}" in
  build | gh-deploy) ;;
  # serve, mike, --help, anything else: exec, so signals reach mkdocs directly.
  *) exec mkdocs "$@" ;;
esac

mkdocs "$@" && exit 0
status=$?

if [ ! -w . ]; then
  echo "mkdocs-material-pinned: $(pwd) is not writable by uid $(id -u) — this image runs as a non-root user," >&2
  echo "and a bind mount keeps the ownership it has on the host." >&2
  echo "  docker run --rm --user \"\$(id -u):\$(id -g)\" -v \"\$PWD:/docs\" <image> $*" >&2
  echo "or point site_dir/--site-dir at a path the container can write." >&2
fi

exit "$status"
