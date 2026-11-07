@domain:branding @area:logo @from:stylesheets/extra
Feature: No borrowed logo in the header
  Stops the project from showing someone else's glyph as its brand while it has no logo of its own.

  @id:docs.branding.logo.001 @rule:branding.logo.generic-stand-in-hidden @inferred @source:docs/stylesheets/extra.css#.md-header__button.md-logo @questionable
  Scenario: The generic stand-in logo is not shown
    Given the project has not configured a logo
    When a reader views any docs page
    Then no logo appears in the header
    And no logo appears in the navigation drawer title
