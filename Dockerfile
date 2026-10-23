FROM node:22-bookworm

# OSS Scanner clones this tiny mirror instead of the site's multi-gigabyte Git
# history. The build still fetches the exact site commit below and runs the
# project's own build, so the scanned source is the production repository.
ARG FRONTALIERE_SITE_COMMIT=51d4352e369d784ad8d0805400c6dc9df09e3d64
ENV DEBIAN_FRONTEND=noninteractive \
    CI=1 \
    FRONTALIERE_BUILD_MAX_OLD_SPACE_SIZE=14336

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates git build-essential python3 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /src

RUN set -eux; \
    git -c protocol.version=2 -c http.version=HTTP/2 clone --depth 1 --no-tags \
      --filter=blob:none https://github.com/valerielinc-ops/frontaliere-si-o-no.git /tmp/frontaliere-site; \
    git -C /tmp/frontaliere-site fetch --depth 1 origin "${FRONTALIERE_SITE_COMMIT}"; \
    git -C /tmp/frontaliere-site checkout --detach "${FRONTALIERE_SITE_COMMIT}"; \
    test "$(git -C /tmp/frontaliere-site rev-parse HEAD)" = "${FRONTALIERE_SITE_COMMIT}"; \
    cp -a /tmp/frontaliere-site/. /src/; \
    rm -rf /tmp/frontaliere-site

RUN npm ci --no-audit --no-fund
RUN npm run build:fast
