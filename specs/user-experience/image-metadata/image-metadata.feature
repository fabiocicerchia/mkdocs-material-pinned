@domain:user-experience @area:image-metadata @from:mkdocs-material-pinned/dockerfile
Feature: Describing the image to registries and users
  Lets registries, scanners and users identify the image, its licence and its source without pulling and inspecting it.

  @id:user-experience.image-metadata.001 @rule:image.metadata.oci-labels @inferred @source:Dockerfile#LABEL
  Scenario Outline: The image carries standard labels for title, description, licence and source
    When a registry or user inspects the image's labels
    Then label <label> reads <value>

    Examples:
      | label                                | value                                                                           |
      | org.opencontainers.image.title       | mkdocs-material-pinned                                                          |
      | org.opencontainers.image.description | MkDocs + Material + common plugins, version-pinned for reproducible docs builds |
      | org.opencontainers.image.licenses    | Apache-2.0                                                                      |
      | org.opencontainers.image.source      | https://github.com/fabiocicerchia/mkdocs-material-pinned                        |

  @id:user-experience.image-metadata.002 @rule:image.metadata.licence-notice-shipped @inferred @source:Dockerfile#COPY
  Scenario: The licence notice ships inside the image
    When a user lists the root of the image's filesystem
    Then the NOTICE file from the project is present at /NOTICE
