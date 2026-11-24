# Official MariaDB image pins for the Ubuntu variant. Each digest identifies
# the complete multi-platform image index.
BASE_IMAGE_REPOSITORY := mariadb
BASE_IMAGE_VERSION_SUFFIX :=

BASE_IMAGE_DIGEST_11.4.13 := sha256:a8992b5e5404d11e03c54a31d0c1bdea3fd116d283aa6d1a627551f29045309b
BASE_IMAGE_DIGEST_11.8.9 := sha256:e1d5495f445654134f226f55a41ce0da227116f6f27f283101f405c794d841fc
BASE_IMAGE_DIGEST_12.3.3 := sha256:4aaf88b3106382c8c18e49f0cec60267be618fc22f858c4503afb2a2555afed3

# Fail before building when a version has no reviewed pin.
BASE_IMAGE = $(BASE_IMAGE_REPOSITORY):$(BASE_IMAGE_TAG)@$(or $(BASE_IMAGE_DIGEST_$(BASE_IMAGE_TAG)),$(error No base image digest for $(BASE_IMAGE_REPOSITORY):$(BASE_IMAGE_TAG); update ubuntu/base-images.mk))
