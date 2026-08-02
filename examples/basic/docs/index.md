# Pinned docs demo

If you are reading this rendered, the image works and every plugin in
`mkdocs.yml` loaded under `--strict`.

!!! note "This admonition is the test"

    It renders only because `admonition` is enabled. Under `--strict`, a
    markdown extension that failed to load is a build failure rather than a
    paragraph of literal `!!! note`.

```python title="pymdownx.superfences"
def hello() -> str:
    return "syntax highlighting and the title above both come from the theme"
```

The footer of this page shows a last-updated date, from
`git-revision-date-localized`. In a shallow checkout it reads 1970 — which is
the failure this example exists to make visible.
