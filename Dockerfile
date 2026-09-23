# Docker Sandboxes template: pinned OpenCode v2 on the opencode-docker variant.
# Build:  docker build -t sbx-opencode2:local .
# Bump:   Renovate opens PRs for the base image digest and OPENCODE_VERSION;
#         merge, then tag the commit as v<version> to release.

# renovate: datasource=docker depName=docker/sandbox-templates
FROM docker/sandbox-templates:opencode-docker@sha256:ef636291701f88bbe1a268bd083175804a84309c14faf75bc8c2ed179ce61db3

# renovate: datasource=npm depName=@opencode/cli
ARG OPENCODE_VERSION=2.0.15

LABEL org.opencontainers.image.source=https://github.com/nikbucher/sbx-opencode2
LABEL org.opencontainers.image.description="Docker Sandboxes template with a pinned OpenCode v2 release"
LABEL org.opencontainers.image.licenses=MIT

# The base image ships OpenCode V1 (npm package "opencode-ai").
# Replace it with a pinned V2 release from the @opencode/cli package.
USER root
RUN npm uninstall -g opencode-ai \
    && npm install -g "@opencode/cli@${OPENCODE_VERSION}" \
    && npm cache clean --force \
    && opencode --version

USER agent
