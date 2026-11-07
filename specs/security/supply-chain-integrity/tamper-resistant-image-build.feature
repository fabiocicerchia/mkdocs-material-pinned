@domain:security @area:supply-chain-integrity @from:mkdocs-material-pinned/dockerfile
Feature: Refusing tampered or drifting image inputs
  Gives maintainers and consumers confidence that the image is built only from the exact base image and package files that were reviewed, so a tampered or re-tagged upstream artifact cannot slip in.

  @id:security.supply-chain-integrity.001 @rule:security.supply-chain.packages-must-match-locked-hashes @inferred @source:Dockerfile#RUN
  Scenario: The image does not build when a package does not match its locked hash
    Given the lockfile records a hash for every package
    And a downloaded package's contents differ from its recorded hash, or a package has no recorded hash
    When the maintainer builds the image
    Then the image build fails at package installation
    And no image is produced with the mismatched package

  @id:security.supply-chain-integrity.002 @rule:security.supply-chain.base-image-pinned-by-digest @inferred @source:Dockerfile#FROM
  Scenario: Rebuilding the image always starts from the same reviewed base image
    Given upstream has re-published the python 3.14-slim-bookworm tag with different contents
    When the maintainer rebuilds the image
    Then the build uses the base image with the pinned digest, not the re-published tag
    And a base image whose digest no longer resolves fails the build instead of being substituted
