# sbx-opencode2

Run OpenCode v2 in [Docker Sandboxes](https://docs.docker.com/ai/sandboxes/customize/templates/) with a consistent starting version, on amd64 and arm64.

The base template ships OpenCode V1; this image swaps in the pinned V2 CLI, so every sandbox starts with the exact same OpenCode release. `/update` inside a running sandbox upgrades only that sandbox — the durable path to a newer OpenCode is a newer image tag.

## Use it

The Docker Hub image is public — no pull credentials needed:

```sh
sbx run --template nikbucher/sbx-opencode2:latest opencode
```

Or from GHCR. If the package is still private, store pull credentials once:

```sh
sbx run --template ghcr.io/nikbucher/sbx-opencode2:latest opencode
```

```sh
gh auth token | sbx secret set --registry ghcr.io --password-stdin
```

Pick a version with the tag: `latest` tracks the most recent publish, an OpenCode version tag like `:2.0.20` pins a specific release, and both move forward as new images are published — pin the image digest for a build that never changes.

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

[Renovate](https://docs.renovatebot.com/) opens PRs for the pinned `@opencode/cli` version and base image digest; low-risk updates automerge once CI passes, majors wait for manual approval. Merging a version bump is the release — no manual tagging needed: CI smoke-tests and pushes the image tagged with the `OPENCODE_VERSION` from the `Dockerfile` and `latest` to both [GHCR](https://github.com/nikbucher/sbx-opencode2/pkgs/container/sbx-opencode2) and [Docker Hub](https://hub.docker.com/r/nikbucher/sbx-opencode2), as the same multi-arch manifest with identical digest. Merges that change nothing build-relevant skip the build. Details on the pipeline, attestations, and registry cleanup live in [CONTRIBUTING.md](CONTRIBUTING.md).

## Files

| Path | Purpose |
| ---- | ------- |
| `Dockerfile` | Template image (multi-arch: amd64 + arm64), base image pinned by digest |
| `.github/workflows/publish.yml` | Smoke test + build + push to `ghcr.io` and Docker Hub on `main` (PRs: build + smoke test only; docs-only changes skip the build) |
| `.github/workflows/cleanup-registry.yml` | Weekly opt-in cleanup of untagged images and one-time manual removal of legacy tags |
| `renovate.json` | Automated update PRs (OpenCode version, base image digest, actions), automerges low-risk updates |
