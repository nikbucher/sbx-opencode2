# Docker Sandboxes template: pinned OpenCode v2 on the shell-docker variant.
# Build:  docker build -t sbx-opencode2:local .
# Bump:   Renovate opens PRs for the base image digest and OPENCODE_VERSION;
#         merging to main publishes the version-tagged image.

# shell-docker is opencode-docker without the OpenCode V1 layer (~520 MB
# compressed). An npm uninstall on top of opencode-docker would only add
# whiteouts; the V1 layer would still ship in the image.
# renovate: datasource=docker depName=docker/sandbox-templates
FROM docker/sandbox-templates:shell-docker@sha256:1560168ac5fb9ce23d413c878349334c5845c07e264cd675d7867f0c78ad1761

# renovate: datasource=npm depName=@opencode/cli
ARG OPENCODE_VERSION=2.0.32

LABEL org.opencontainers.image.source=https://github.com/nikbucher/sbx-opencode2
LABEL org.opencontainers.image.description="Docker Sandboxes template with a pinned OpenCode v2 release"
LABEL org.opencontainers.image.licenses=MIT

# Install a pinned V2 release from the @opencode/cli package.
# Run the install as agent, not root: the base image's NPM_CONFIG_PREFIX
# is agent-owned, and agent-owned package files are what make in-sandbox
# self-updates (/update, opencode upgrade) work at all.
# The platform packages carry no libc field, so npm installs several linux
# variants (glibc/musl x baseline, ~200 MB each) even with --omit=optional.
# The postinstall already put the matching binary into bin/, so drop the
# nested platform packages afterwards.
USER agent
RUN npm install -g --omit=optional "@opencode/cli@${OPENCODE_VERSION}" \
    && rm -rf "$(npm root -g)/@opencode/cli/node_modules" \
    && npm cache clean --force \
    && opencode --version

CMD ["opencode"]
