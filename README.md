# sbx-opencode2

[![Publish template image](https://github.com/nikbucher/sbx-opencode2/actions/workflows/publish.yml/badge.svg)](https://github.com/nikbucher/sbx-opencode2/actions/workflows/publish.yml)
[![Docker Image Version](https://img.shields.io/docker/v/nikbucher/sbx-opencode2?sort=semver&label=opencode%20version)](https://hub.docker.com/r/nikbucher/sbx-opencode2)
[![Platform](https://img.shields.io/badge/platform-amd64%20%7C%20arm64-blue)](https://docs.docker.com/build/building/multi-platform/)
[![OpenCode](https://img.shields.io/badge/OpenCode-v2-DEA584)](https://github.com/sst/opencode)
[![License: MIT](https://img.shields.io/github/license/nikbucher/sbx-opencode2)](LICENSE)

Run OpenCode v2 in [Docker Sandboxes](https://docs.docker.com/ai/sandboxes/customize/templates/) with a consistent starting version, on amd64 and arm64.

The image builds on the `shell-docker` sandbox template and adds the pinned OpenCode V2 CLI, so every sandbox starts with the exact same OpenCode release. `/update` inside a running sandbox upgrades only that sandbox — the durable path to a newer OpenCode is a newer image tag. The image keeps only the binary for its platform; an in-sandbox update reinstalls the unused libc variant too, adding ~200 MB to that sandbox.

## Use it

The Docker Hub image is public — no pull credentials needed:

```sh
sbx run --template nikbucher/sbx-opencode2:latest opencode
```

For GHCR, store pull credentials first only if the package is private:

```sh
gh auth token | sbx secret set --registry ghcr.io --password-stdin
```

```sh
sbx run --template ghcr.io/nikbucher/sbx-opencode2:latest opencode
```

`latest` tracks the most recent publish. An OpenCode version tag like `:2.0.20` fixes the OpenCode version but can point to a rebuilt image; pin the image digest to fix the exact image.

### Without a registry (local build)

```sh
docker build -t sbx-opencode2:local .
docker image save sbx-opencode2:local -o sbx-opencode2.tar
sbx template load sbx-opencode2.tar
sbx run -t sbx-opencode2:local opencode
```

## Build and verify locally

```sh
docker build -t sbx-opencode2:local .
docker run --rm sbx-opencode2:local opencode --version
```

## Releases and updates

Renovate proposes OpenCode and base-image updates; merging build-relevant changes to `main` publishes tested images tagged with the OpenCode version and `latest`. See [CONTRIBUTING.md](CONTRIBUTING.md) for release, CI, and maintenance details.
