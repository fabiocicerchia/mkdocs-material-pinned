@domain:content-presentation @area:tables @from:stylesheets/extra
Feature: Card-styled tables
  Makes reference tables easy to scan for readers and promises they stay usable on narrow screens.

  Background:
    Given a docs page contains a plain Markdown table

  @id:docs.content-presentation.tables.001 @rule:content-presentation.tables.card-with-compact-headers @inferred @source:docs/stylesheets/extra.css#.md-typeset table:not([class])
  Scenario: Tables appear as rounded cards with compact uppercase headers
    When a reader views the page
    Then the table has rounded corners and a hairline border
    And column headers are shown in small, semi-bold, letter-spaced capitals

  @id:docs.content-presentation.tables.002 @rule:content-presentation.tables.wide-table-overflow @inferred @source:docs/stylesheets/extra.css#.md-typeset table:not([class]) @questionable
  Scenario: A table wider than the screen is cut off at the card edge
    Given the table is wider than the reader's screen
    When a reader views the page on a narrow screen
    Then columns beyond the card's right edge are clipped
    And the table cannot be scrolled sideways to reveal them
