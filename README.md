# sbx-opencode2

Run OpenCode v2 in [Docker Sandboxes](https://docs.docker.com/ai/sandboxes/customize/templates/) with a consistent starting version, on amd64 and arm64.

The base template ships OpenCode V1; this image swaps in the pinned V2 CLI, so every sandbox starts with the exact same OpenCode release. `/update` inside a running sandbox upgrades only that sandbox — the durable path to a newer OpenCode is a newer image tag.

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
