@domain:security @area:security-scanning @from:mkdocs-material-pinned/makefile
Feature: Scanning the tree the way CI does
  Maintainers can run the same vulnerability, misconfiguration and secret scan locally before CI flags it.

  @id:security.security-scanning.001 @rule:security.scanning.requires-trivy @inferred @source:Makefile#analyze
  Scenario: The scan refuses to run without trivy and says where to get it
    Given trivy is not installed
    When the maintainer runs make analyze
    Then the error output reads "analyze needs trivy: https://trivy.dev/latest/getting-started/installation/"
    And the command exits with status 69

  @id:security.security-scanning.002 @rule:security.scanning.critical-and-high-only @inferred @source:Makefile#analyze
  Scenario: The scan reports only critical and high findings across vulnerabilities, misconfigurations and secrets
    Given trivy is installed
    When the maintainer runs make analyze
    Then the repository is scanned for vulnerabilities, misconfigurations and secrets
    And only CRITICAL and HIGH findings are reported
