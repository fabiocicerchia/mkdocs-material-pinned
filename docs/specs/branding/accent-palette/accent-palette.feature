@domain:branding @area:accent-palette @from:stylesheets/extra
Feature: Branding the docs with one accent pair
  Lets a maintainer re-brand the whole docs site and its splash page by changing one pair of colours, so every project in the portfolio reads as one family.

  Background:
    Given the docs site uses the bundled stylesheet with the custom primary and accent colours

  @id:docs.branding.accent-palette.001 @rule:branding.accent-palette.one-pair-drives-site-colours @inferred @source:docs/stylesheets/extra.css#:root @questionable
  Scenario Outline: The accent pair sets the colour of chrome, links and interactive elements
    Given the maintainer has set the accent pair to <accent> and <accent_2>
    When a reader opens any docs page
    Then the theme's primary colour is <accent_2>
    And the theme's interactive accent colour is <accent>
    And the hero title and primary buttons blend from <accent> to <accent_2>

    Examples:
      | accent  | accent_2 |
      | #38bdf8 | #3b82f6  |
      | #34d399 | #059669  |

  @id:docs.branding.accent-palette.002 @rule:site-delivery.splash.shares-docs-palette @inferred @source:docs/stylesheets/extra.css#:root
  Scenario: The splash page and the docs show the same accent colours
    Given the splash page is served at the site root and the docs at /docs/
    And the maintainer has changed the accent pair once
    When a visitor opens the splash page
    Then the splash title gradient and install label use the same accent pair as the docs
    And no second copy of the palette has to be edited
