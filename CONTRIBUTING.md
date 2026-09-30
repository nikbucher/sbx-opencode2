# Contributing

## CI: build and publish

`.github/workflows/publish.yml` runs on every PR and every push to `main`. It detects build-relevant changes (`Dockerfile`, `.dockerignore`, the workflow itself), comparing push endpoints with a two-dot diff and PRs against the merge base with a three-dot diff. Relevant changes trigger an amd64 smoke test — the OpenCode version must match the `Dockerfile` and the npm prefix must be writable by `agent` — and a multi-arch (amd64 + arm64) build. PRs build and test without publishing. Only relevant pushes to `main` and manual runs on `main` publish to GHCR and Docker Hub with provenance attestations, tagged with `OPENCODE_VERSION` from the `Dockerfile` and `latest`.

Docs-only changes skip the build but the required `build-and-push` job still succeeds. Manual runs (`workflow_dispatch`) always build; runs on other branches do not publish. If the comparison base is unavailable (new branch, missing commit), the build runs conservatively. Actual diff errors fail the job rather than reporting a successful skip.

## Files

| Path | Purpose |
| ---- | ------- |
| `Dockerfile` | Template image (multi-arch: amd64 + arm64), base image pinned by digest |
| `.dockerignore` | Limits the build context to the Dockerfile |
| `.github/workflows/publish.yml` | Change detection, smoke tests, multi-arch build, and publication on `main` |
| `.github/workflows/cleanup-registry.yml` | Weekly opt-in cleanup of untagged images and one-time manual removal of legacy tags |
| `renovate.json` | Automated update PRs (OpenCode version, base image digest, actions), automerges low-risk updates |

## Registry cleanup

`cleanup-registry.yml` runs weekly and removes untagged images older than 30 days while preserving tagged images and their multi-arch components. Cleanup is opt-in: run the workflow manually in dry-run mode to inspect candidates, then set the repository variable `GHCR_CLEANUP_ENABLED=true` to enable automatic weekly deletion.

To remove old `sha-*`, `main`, and `pr-*` tags once, run the workflow manually with `legacy_tags` checked: inspect the default dry run, then repeat with `dry_run` unchecked. This removes only the matching tags, even if an image also has a version tag or `latest`; no new legacy tags are published.

## Renovate

Renovate opens PRs for the OpenCode version, the base image digest, and GitHub Actions (see `renovate.json`). Low-risk updates (base image digest, OpenCode minor/patch, action minor/patch/digest) automerge once CI passes. Majors are manual: an OpenCode major (v3 or later) waits in the Renovate dependency dashboard until you approve it there, and action majors arrive as regular PRs to review and merge.
