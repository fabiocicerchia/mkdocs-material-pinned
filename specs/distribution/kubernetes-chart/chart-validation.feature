@domain:distribution @area:kubernetes-chart @from:chart/check
Feature: Validating the Helm chart
  Gives the operator a single command that confirms the Kubernetes chart lints and renders a deployable workload with default values before it is shipped or installed.

  Background:
    Given the Helm chart ships alongside the image
    And Docker is available on the operator's machine

  @id:distribution.kubernetes-chart.001 @rule:distribution.kubernetes-chart.check-passes-on-valid-chart @inferred @source:chart/check.sh#helm
  Scenario: A chart that lints and renders a container image passes the check
    Given the chart lints without errors
    And the chart rendered with its default values declares a container image
    When the operator runs the chart check
    Then the output ends with "OK"
    And the check exits with status 0

  @id:distribution.kubernetes-chart.002 @rule:distribution.kubernetes-chart.check-fails-on-broken-chart @inferred @source:chart/check.sh#helm
  Scenario Outline: A chart that fails to lint, render or declare an image fails the check
    Given <defect>
    When the operator runs the chart check
    Then the check exits with a non-zero status
    And "OK" is not printed

    Examples:
      | defect                                                                 |
      | the chart has a lint error                                             |
      | a template fails to render with the default values                     |
      | the chart rendered with its default values declares no container image |
