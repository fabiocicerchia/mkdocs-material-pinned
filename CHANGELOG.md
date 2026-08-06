# Changelog

All notable changes to this project are documented here.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## 1.0.0 (2026-08-06)


### Features

* **chart:** add Helm chart ([a2e1fd5](https://github.com/fabiocicerchia/mkdocs-material-pinned/commit/a2e1fd5b72c14e867a9ed5966189b2815f3d6939))


### Bug Fixes

* build the smoke-test site as the calling user ([16c68b2](https://github.com/fabiocicerchia/mkdocs-material-pinned/commit/16c68b2fdbd710ad5e3fddac1584b630dcde9c35))
* **ci:** stop security workflows failing on private repos ([#14](https://github.com/fabiocicerchia/mkdocs-material-pinned/issues/14)) ([c6fe113](https://github.com/fabiocicerchia/mkdocs-material-pinned/commit/c6fe11334c28afe4e561a81e1898bf7aaf4fb56b))
* **pre-commit:** stop check-yaml failing on Helm templates and multi-doc manifests ([0131e53](https://github.com/fabiocicerchia/mkdocs-material-pinned/commit/0131e533c98cf4cf527f8eeefc2828391ca46f65))

## [Unreleased]

### Added

- MkDocs + Material image with the whole plugin set pinned in
  `requirements.txt`; image tag mirrors the bundled `mkdocs-material`
  version. `mike` included for versioned deploys.

Not yet released.
