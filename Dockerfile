# Docker Sandboxes template: pinned OpenCode v2 on the opencode-docker variant.
# Build:  docker build -t sbx-opencode2:local .
# Bump:   Renovate opens PRs for the base image digest and OPENCODE_VERSION;
#         merging to main publishes the version-tagged image.

# renovate: datasource=docker depName=docker/sandbox-templates
FROM docker/sandbox-templates:opencode-docker@sha256:d23d51e1eaa7c23db723b3cd547fc998829b5c147579c512c7222efd30761fdd

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
