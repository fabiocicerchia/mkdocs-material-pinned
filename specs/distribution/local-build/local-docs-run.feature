@domain:distribution @area:local-build @from:mkdocs-material-pinned/makefile
Feature: Running the docs image against the current folder
  Authors preview or build the docs in their working folder through the pinned image with one command.

  Background:
    Given the lockfile matches the pin list

  @id:distribution.local-build.001 @rule:distribution.local.run-uses-current-folder @inferred @source:Makefile#run
  Scenario Outline: Running the image works on the current folder and forwards the chosen mkdocs subcommand
    Given the author is in a folder containing mkdocs.yml
    When the author runs make run with ARGS="<args>"
    Then the image is built first
    And the current folder is mounted as the docs project
    And <outcome>
    And the container is removed when it stops

    Examples:
      | args  | outcome                                                       |
      |       | the docs are served with live reload on http://localhost:8000 |
      | build | the static site is written into ./site                        |

  @id:distribution.local-build.002 @rule:distribution.installation.pull-version-tag @inferred @source:Makefile#install
  Scenario: Installing pulls the published image for the current version
    When the operator runs make install
    Then ghcr.io/fabiocicerchia/mkdocs-material-pinned:9.7.7 is pulled onto the machine
