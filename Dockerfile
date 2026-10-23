FROM node:22-bookworm

# OSS Scanner clones this tiny mirror instead of the site's multi-gigabyte Git
# history. The build still fetches the exact site commit below and runs the
# project's own build, so the scanned source is the production repository.
ARG FRONTALIERE_SITE_COMMIT=51d4352e369d784ad8d0805400c6dc9df09e3d64
ENV DEBIAN_FRONTEND=noninteractive \
    CI=1 \
    FRONTALIERE_BUILD_MAX_OLD_SPACE_SIZE=14336

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl git build-essential python3 tar \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /src

RUN set -eu; \
    archive="/tmp/frontaliere-site.tar.gz"; \
    curl --fail --location --retry 5 --retry-all-errors \
      "https://codeload.github.com/valerielinc-ops/frontaliere-si-o-no/tar.gz/${FRONTALIERE_SITE_COMMIT}" \
      --output "$archive"; \
    tar --extract --gzip --file "$archive" --strip-components=1 --directory /src; \
    rm -f "$archive"

RUN npm ci --no-audit --no-fund
RUN npm run build:fast
