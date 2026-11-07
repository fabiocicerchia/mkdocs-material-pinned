@domain:landing-page @area:feature-cards @from:stylesheets/extra
Feature: Feature cards with depth
  Presents the project's features as icon-led cards that react when a visitor points at them.

  Background:
    Given a page shows a grid of feature cards

  @id:docs.landing-page.feature-cards.001 @rule:landing-page.feature-cards.accent-icons-and-hover-lift @inferred @source:docs/stylesheets/extra.css#.md-typeset .grid.cards > ul > li @questionable
  Scenario: Feature cards show accent-coloured icons and lift on hover
    When a visitor hovers over a feature card
    Then each card has rounded corners and a hairline border
    And card icons are shown in the first accent colour
    And the hovered card rises slightly, its border tints toward the accent and it casts a deeper shadow
