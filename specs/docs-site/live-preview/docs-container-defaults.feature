@domain:docs-site @area:live-preview @from:mkdocs-material-pinned/dockerfile
Feature: Previewing and building docs with the image
  Gives docs authors and CI pipelines a container that, with no extra flags, previews the mounted docs project and builds it with the bundled git-aware plugins.

  Background:
    Given the docs project (mkdocs.yml and docs/) is mounted at /docs in the container

  @id:docs-site.live-preview.001 @rule:docs.preview.default-serve-on-port-8000 @inferred @source:Dockerfile#CMD
  Scenario: With no command, the container serves the docs on port 8000 for the host
    Given port 8000 of the container is published on the host
    When the docs author starts the container without a command
    Then mkdocs serve runs against the project in /docs
    And the site answers on http://localhost:8000 from the host
    And the container declares port 8000 as exposed

  @id:docs-site.live-preview.002 @rule:docs.build.mounted-project-builds-site @inferred @source:Dockerfile#WORKDIR
  Scenario: Building the mounted project writes the static site next to it
    Given the project enables the material theme with the search, minify and awesome-pages plugins
    And the container runs as the caller's own uid and gid
    When the CI pipeline runs the image with "build --strict"
    Then the command exits 0
    And site/index.html exists in the mounted project folder

  @id:docs-site.live-preview.003 @rule:docs.plugins.git-available-for-revision-and-versioning @inferred @source:Dockerfile#RUN
  Scenario: Plugins that read git history work inside the container
    Given the mounted project is a git checkout
    And the project enables git-revision-date-localized or publishes versions with mike
    And the container runs as the caller's own uid and gid
    When the docs author builds the docs with the image
    Then the git command is available to those plugins inside the container
    And pages carry their git revision dates instead of failing for lack of git
