# mkdocs-material-pinned — MkDocs + Material + common plugins, fully pinned
# for reproducible docs builds. `docs as code` without version drift.
FROM python:3.14-slim-bookworm
LABEL org.opencontainers.image.title="mkdocs-material-pinned" \
      org.opencontainers.image.description="MkDocs + Material + common plugins, version-pinned for reproducible docs builds" \
      org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.source="https://github.com/fabiocicerchia/mkdocs-material-pinned"
# git is needed by git-revision-date-localized and mike
RUN apt-get update && apt-get install -y --no-install-recommends git \
 && rm -rf /var/lib/apt/lists/* \
 && useradd -m -u 10001 docs
COPY requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt
USER 10001
WORKDIR /docs
EXPOSE 8000
ENTRYPOINT ["mkdocs"]
CMD ["serve", "--dev-addr=0.0.0.0:8000"]
