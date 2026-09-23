# Docker Sandboxes template: pinned OpenCode v2 on the opencode-docker variant.
# Build:  docker build -t sbx-opencode2:local .
# Bump:   change OPENCODE_VERSION, commit, then tag the commit as v<version>.

ARG OPENCODE_VERSION=2.0.15

FROM docker/sandbox-templates:opencode-docker
ARG OPENCODE_VERSION

LABEL org.opencontainers.image.source=https://github.com/nikbucher/sbx-opencode2
LABEL org.opencontainers.image.description="Docker Sandboxes template with a pinned OpenCode v2 release"
LABEL org.opencontainers.image.licenses=MIT

# The base image ships OpenCode V1 (npm package "opencode-ai").
# Replace it with a pinned V2 release from the @opencode/cli package.
USER root
RUN npm uninstall -g opencode-ai \
    && npm install -g "@opencode/cli@${OPENCODE_VERSION}"

USER agent
