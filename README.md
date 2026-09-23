# sbx-opencode2

Docker Sandboxes template with a **pinned OpenCode v2** release, based on [`docker/sandbox-templates:opencode-docker`](https://docs.docker.com/ai/sandboxes/customize/templates/).

The base image ships OpenCode V1 (npm package `opencode-ai`). This template swaps it for the V2 CLI (`@opencode/cli`) at a fixed version, so every sandbox starts with the exact same OpenCode release.

## Use it

```sh
sbx run --template ghcr.io/nikbucher/sbx-opencode2:2.0.15 opencode
```

Images are built and pushed to GHCR by GitHub Actions on every `v*` tag. Tags: `2.0.15` (release), `latest`, `main`, `sha-<commit>`. If the package is still private, store pull credentials once:

```sh
gh auth token | sbx secret set --registry ghcr.io --password-stdin
```

### Without a registry (local build)

```sh
docker build -t sbx-opencode2:2.0.15 .
docker image save sbx-opencode2:2.0.15 -o sbx-opencode2.tar
sbx template load sbx-opencode2.tar
sbx run -t sbx-opencode2:2.0.15 opencode
```

## Build and verify locally

```sh
docker build -t sbx-opencode2:local .
docker run --rm sbx-opencode2:local opencode --version   # -> 2.0.15
```

## Bump the OpenCode version

[Renovate](https://docs.renovatebot.com/) opens PRs that update the pinned `@opencode/cli` version (restricted to the v2 major) and the pinned base image digest. Low-risk updates (actions, base image digest, OpenCode minor/patch) are merged automatically once CI passes; major OpenCode updates only appear in the Renovate dependency dashboard.

Every merge rebuilds `main` and `latest` (after the smoke test passes). To cut a release, tag the merged commit: `git tag v2.0.x && git push origin v2.0.x`. The tag must match `OPENCODE_VERSION` in the `Dockerfile` (without the `v` prefix).

## Files

| Path | Purpose |
| ---- | ------- |
| `Dockerfile` | Template image (multi-arch: amd64 + arm64), base image pinned by digest |
| `.github/workflows/publish.yml` | Smoke test + build + push to `ghcr.io` on tags, `main`, and PRs |
| `renovate.json` | Automated update PRs (OpenCode version, base image digest, actions), automerges low-risk updates |
