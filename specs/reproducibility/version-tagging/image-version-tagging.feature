@domain:reproducibility @area:version-tagging @from:mkdocs-material-pinned/makefile
Feature: Tagging and releasing the image by its mkdocs-material version
  Docs pipelines pin to an image tag that is meant to equal the bundled mkdocs-material version, with latest as a moving alias.

  @id:reproducibility.version-tagging.001 @rule:reproducibility.tagging.default-tag-is-material-version @inferred @source:Makefile#VERSION @questionable
  Scenario: The image tag defaults to a version that no longer matches the bundled mkdocs-material
    Given the pin list names mkdocs-material==9.8.0
    And the maintainer does not set VERSION
    When the maintainer builds the image
    Then the image is tagged ghcr.io/fabiocicerchia/mkdocs-material-pinned:9.7.7

  @id:reproducibility.version-tagging.002 @rule:reproducibility.tagging.release-version-and-latest @inferred @source:Makefile#release
  Scenario Outline: A release publishes the version tag and latest for amd64 and arm64
    When the maintainer runs make release
    Then ghcr.io/fabiocicerchia/mkdocs-material-pinned:<version> is pushed
    And ghcr.io/fabiocicerchia/mkdocs-material-pinned:latest is pushed
    And both tags carry linux/amd64 and linux/arm64 images

    Examples:
      | version |
      | 9.7.7   |

  @id:reproducibility.version-tagging.003 @rule:distribution.publishing.push-version-tag-only @inferred @source:Makefile#push
  Scenario: Pushing publishes only the version tag, never latest
    Given the lockfile matches the pin list
    When the maintainer runs make push
    Then ghcr.io/fabiocicerchia/mkdocs-material-pinned:9.7.7 is built and pushed
    And latest is left unchanged
