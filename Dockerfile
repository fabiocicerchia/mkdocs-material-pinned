# mkdocs-material-pinned — MkDocs + Material + common plugins, fully pinned
# for reproducible docs builds. `docs as code` without version drift.
FROM python:3.14-slim-bookworm@sha256:23c59390fc717bf09f9336908199a0ae75d9c4264bf296123f94ad772fea3b52
LABEL org.opencontainers.image.title="mkdocs-material-pinned" \
      org.opencontainers.image.description="MkDocs + Material + common plugins, version-pinned for reproducible docs builds" \
      org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.source="https://github.com/fabiocicerchia/mkdocs-material-pinned"
COPY NOTICE /NOTICE
COPY requirements.txt /tmp/requirements.txt
# One layer: every extra `RUN ... install` is another layer to transfer and
# store on every pull. git is needed by git-revision-date-localized and mike.
RUN apt-get update && apt-get install -y --no-install-recommends git \
 && rm -rf /var/lib/apt/lists/* \
 && useradd -m -u 10001 docs \
 && pip install --no-cache-dir -r /tmp/requirements.txt
USER 10001
WORKDIR /docs
EXPOSE 8000
ENTRYPOINT ["mkdocs"]
CMD ["serve", "--dev-addr=0.0.0.0:8000"]
