@domain:security @area:non-root-runtime @from:mkdocs-material-pinned/dockerfile
Feature: Running the docs container without root
  Lets operators run the image without granting root inside the container, a fixed uid they can plan file ownership around.

  @id:security.non-root-runtime.001 @rule:security.runtime.runs-as-uid-10001 @inferred @source:Dockerfile#USER
  Scenario: The container runs as the unprivileged uid 10001 unless the operator overrides it
    Given the operator does not pass a --user option
    When the operator starts the container
    Then mkdocs runs as uid 10001, not as root
    And files the container writes to a mount are owned by uid 10001
