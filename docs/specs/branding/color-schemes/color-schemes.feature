@domain:branding @area:color-schemes @from:stylesheets/extra
Feature: Legible light and dark schemes
  Keeps links, header and backgrounds readable for readers whichever colour scheme they pick or their OS prefers.

  Background:
    Given the docs site offers light, dark and follow-the-system schemes

  @id:docs.branding.color-schemes.001 @rule:branding.color-schemes.links-readable-per-scheme @inferred @source:docs/stylesheets/extra.css#[data-md-color-scheme="slate"]
  Scenario Outline: Each colour scheme uses the accent shade that stays readable on its background
    Given the reader has chosen the <scheme> scheme
    When the reader views a docs page
    Then links are shown in <link_colour>
    And the page background is <background>
    And the header and navigation tabs sit on <header_background>

    Examples:
      | scheme | link_colour                        | background                          | header_background   |
      | light  | the second accent colour (#3b82f6) | Material's default light background | the page background |
      | dark   | the first accent colour (#38bdf8)  | #0b0f1a                             | #0b0f1a             |
