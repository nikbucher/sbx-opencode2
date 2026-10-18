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
# The platform binaries are optionalDependencies without a libc field, so
# npm installs both the glibc and musl variant (~200 MB each). The package
# has no other dependencies, and the postinstall hard-links (or copies) the
# matching binary into bin/, so its nested node_modules can go entirely.
# The empty config dir matches opencode-docker, which ships it agent-owned.
USER agent
RUN npm install -g "@opencode/cli@${OPENCODE_VERSION}" \
    && rm -rf "$(npm root -g)/@opencode/cli/node_modules" \
    && npm cache clean --force \
    && mkdir -p "$HOME/.config/opencode" \
    && opencode --version

# shell-docker defaults to bash; restore opencode-docker's default command.
CMD ["opencode"]
