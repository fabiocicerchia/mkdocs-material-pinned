# mkdocs-material-pinned — MkDocs + Material + common plugins, fully pinned
# for reproducible docs builds. `docs as code` without version drift.
FROM python:3.14-slim-bookworm@sha256:9ab8d9c8514b44f90cf0029dd42fdd7e9e211e639c8b995304cc04568dee900f
LABEL org.opencontainers.image.title="mkdocs-material-pinned" \
      org.opencontainers.image.description="MkDocs + Material + common plugins, version-pinned for reproducible docs builds" \
      org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.source="https://github.com/fabiocicerchia/mkdocs-material-pinned"
COPY NOTICE /NOTICE
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
# requirements.lock is requirements.txt resolved and hashed (`make lock`).
COPY requirements.lock /tmp/requirements.lock
# One layer: every extra `RUN ... install` is another layer to transfer and
# store on every pull. git is needed by git-revision-date-localized and mike.
RUN apt-get update && apt-get install -y --no-install-recommends git \
 && rm -rf /var/lib/apt/lists/* \
 && useradd -m -u 10001 docs \
 && pip install --no-cache-dir --require-hashes -r /tmp/requirements.lock \
 && rm /tmp/requirements.lock
USER 10001
WORKDIR /docs
EXPOSE 8000
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["serve", "--dev-addr=0.0.0.0:8000"]
