# Specifications of mkdocs-material-pinned / docs

What this code does, one atomic Gherkin scenario per behaviour, read from the code by code-atlas.
Tags: `@verified` a test asserts it · `@inferred` read from the code only · `@gap` an entry point no test covers · `@human` written or amended by a person, never rewritten.

## Branding & theming
How the docs site looks as a brand: its colours, colour schemes and identity marks.

- **Accent palette**: [Branding the docs with one accent pair](branding/accent-palette/accent-palette.feature) (2)
- **Light and dark schemes**: [Legible light and dark schemes](branding/color-schemes/color-schemes.feature) (1)
- **Logo**: [No borrowed logo in the header](branding/logo/no-stand-in-logo.feature) (1)

## Content presentation
How the written documentation itself is rendered for reading.

- **Tables**: [Card-styled tables](content-presentation/tables/card-tables.feature) (2)

## Landing page
The product-style home page that introduces the project.

- **Feature cards**: [Feature cards with depth](landing-page/feature-cards/feature-cards.feature) (1)
- **Hero**: [Landing page hero and calls to action](landing-page/hero/landing-hero-and-buttons.feature) (2)

## Site delivery & privacy
How the docs site stays self-contained, consistent and reproducible when published.

- **Offline-safe assets**: [Styling that needs no network](site-delivery/offline-assets/offline-safe-styling.feature) (1)
