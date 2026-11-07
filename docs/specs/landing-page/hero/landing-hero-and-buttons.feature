@domain:landing-page @area:hero @from:stylesheets/extra
Feature: Landing page hero and calls to action
  Gives the home page a product-site look so visitors see what the project is and where to start.

  Background:
    Given a page contains a hero block with a title, a tagline and buttons

  @id:docs.landing-page.hero.001 @rule:landing-page.hero.centred-gradient-title @inferred @source:docs/stylesheets/extra.css#.md-typeset .hero @questionable
  Scenario: The hero shows a centred gradient title over a muted tagline
    When a visitor opens the home page
    Then the hero title and tagline are centred
    And the title is filled with a gradient from the first to the second accent colour
    And the tagline is shown in a lighter text colour and no wider than 42rem

  @id:docs.landing-page.hero.002 @rule:landing-page.call-to-action.pill-buttons-lift-on-hover @inferred @source:docs/stylesheets/extra.css#.md-typeset .md-button @questionable
  Scenario: Call-to-action buttons are pills, and the primary one is gradient-filled
    Given the hero offers a primary and a secondary button
    When the visitor hovers over a button
    Then both buttons are pill-shaped
    And the primary button has a gradient fill from the first to the second accent colour with white text
    And the hovered button lifts slightly and casts an indigo glow
