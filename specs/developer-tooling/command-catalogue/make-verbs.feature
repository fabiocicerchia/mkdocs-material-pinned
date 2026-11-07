@domain:developer-tooling @area:command-catalogue @from:mkdocs-material-pinned/makefile
Feature: Discovering and running the maintenance verbs
  Contributors see every task the repo offers and can apply the auto-fixable parts of the quality gate in one step.

  @id:developer-tooling.command-catalogue.001 @rule:tooling.catalogue.bare-make-lists-verbs @inferred @source:Makefile#help
  Scenario: Running make with no verb lists every task with its description
    When the contributor runs make with no verb
    Then nothing is built
    And each task is listed with its one-line description, e.g. "build      Build the image locally"
    And the list includes help, build, lock, lock-check, lint, test, setup, install, run, format, analyze, push and release

  @id:developer-tooling.command-catalogue.002 @rule:tooling.quality-gate.format-tolerates-fixes @inferred @source:Makefile#format
  Scenario: Auto-fixing whitespace, final newlines and line endings does not fail when files were rewritten
    Given a file has trailing whitespace
    When the contributor runs make format
    Then the trailing whitespace, end-of-file and line-ending hooks run over every file
    And the offending file is rewritten
    And each hook's report is shown
    And make format finishes with status 0
