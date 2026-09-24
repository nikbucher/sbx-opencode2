# sbx-opencode2

Docker Sandboxes template with a **pinned OpenCode v2** release, based on [`docker/sandbox-templates:opencode-docker`](https://docs.docker.com/ai/sandboxes/customize/templates/).

The base image ships OpenCode V1 (npm package `opencode-ai`). This template swaps it for the V2 CLI (`@opencode/cli`) at a fixed version, so every sandbox starts with the exact same OpenCode release.

## Use it

```sh
sbx run --template ghcr.io/nikbucher/sbx-opencode2:latest opencode
```

Images are built and pushed to GHCR by GitHub Actions on every push to `main` (PRs are built and smoke-tested but not pushed). `latest` points to the most recently published image; replace it with an OpenCode version tag to choose a specific version. Both tags can be updated on subsequent merges, so use an image digest to refer to a specific build. If the package is still private, store pull credentials once:

```sh
gh auth token | sbx secret set --registry ghcr.io --password-stdin
```

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

## Bump the OpenCode version

[Renovate](https://docs.renovatebot.com/) opens PRs that update the pinned `@opencode/cli` version and the pinned base image digest. Low-risk updates (base image digest, OpenCode minor/patch, action minor/patch/digest) are merged automatically once CI passes. Major updates stay manual: an OpenCode major (v3 or later) waits in the Renovate dependency dashboard until you approve it there, and action majors arrive as regular PRs you review and merge yourself.

Every merge to `main` runs the smoke test, then builds and pushes the image tagged with the `OPENCODE_VERSION` from the `Dockerfile` and `latest`. Merging a Renovate version bump is the release — no manual tagging needed. The weekly cleanup removes untagged images older than 30 days while preserving the tagged images and their multi-arch components. Run the cleanup workflow manually in dry-run mode to inspect candidates, then set the repository variable `GHCR_CLEANUP_ENABLED=true` to enable automatic weekly deletion. To remove old `sha-*`, `main`, and `pr-*` tags once, run the workflow manually with `legacy_tags` checked: inspect the default dry run, then repeat with `dry_run` unchecked. This removes only the matching tags, even if an image also has a version tag or `latest`; no new legacy tags are published.

## Files

| Path | Purpose |
| ---- | ------- |
| `Dockerfile` | Template image (multi-arch: amd64 + arm64), base image pinned by digest |
| `.github/workflows/publish.yml` | Smoke test + build + push to `ghcr.io` on `main` (PRs: build + smoke test only) |
| `.github/workflows/cleanup-registry.yml` | Weekly opt-in cleanup of untagged images and one-time manual removal of legacy tags |
| `renovate.json` | Automated update PRs (OpenCode version, base image digest, actions), automerges low-risk updates |
