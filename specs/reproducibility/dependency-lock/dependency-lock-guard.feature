@domain:reproducibility @area:dependency-lock @from:mkdocs-material-pinned/makefile
Feature: Refusing to build from a stale lockfile
  Maintainers get a hard stop, with the fix spelled out, when the hashed lockfile no longer matches the pin list, so an image is never built from packages nobody pinned.

  Background:
    Given the pin list names mkdocs-material==9.8.0

  @id:reproducibility.dependency-lock.001 @rule:reproducibility.lock.stale-lock-refuses-build @inferred @source:Makefile#lock-check
  Scenario Outline: A lockfile missing a pinned version stops the build and names the fix
    Given the lockfile still resolves mkdocs-material==9.7.7
    When the maintainer runs make <verb>
    Then no image is built
    And the output reads "requirements.lock is stale, missing: mkdocs-material==9.8.0"
    And the output reads "run: make lock"
    And the command exits with status 1

    Examples:
      | verb  |
      | build |
      | test  |
      | run   |
      | push  |

  @id:reproducibility.dependency-lock.002 @rule:reproducibility.lock.regenerate-from-pins @inferred @source:Makefile#lock
  Scenario: Regenerating the lockfile resolves the pins with a hash per artifact
    Given the lockfile is stale
    When the maintainer runs make lock
    Then the lockfile is rewritten from the pin list
    And every package in it, including transitive ones, carries --hash lines
    And it is resolved for Python 3.14 on every platform

  @id:reproducibility.dependency-lock.003 @rule:reproducibility.lock.release-skips-lock-check @inferred @source:Makefile#release @questionable
  Scenario: A release is built without checking that the lockfile matches the pins
    Given the lockfile still resolves mkdocs-material==9.7.7
    When the maintainer runs make release
    Then no stale-lockfile refusal is shown
    And images are built from the 9.7.7 lockfile and pushed
