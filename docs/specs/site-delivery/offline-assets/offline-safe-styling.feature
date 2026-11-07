@domain:site-delivery @area:offline-assets @from:stylesheets/extra
Feature: Styling that needs no network
  Keeps the docs private, usable offline and reproducible by never fetching fonts or other styling assets from third parties.

  @id:docs.site-delivery.offline-assets.001 @rule:site-delivery.offline-assets.system-fonts-only @inferred @source:docs/stylesheets/extra.css#:root
  Scenario: Docs render in system fonts without downloading any
    Given the reader's device has no network access to font or CDN hosts
    When the reader opens a docs page
    Then body text is shown in the device's system sans-serif font
    And code is shown in the device's system monospace font
    And the styling makes no request to any external host
