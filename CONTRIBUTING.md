# Contributing

## CI: build and publish

`.github/workflows/publish.yml` runs on every PR and every push to `main`. It first detects whether build-relevant files changed (`Dockerfile`, `.dockerignore`, the workflow itself): if they did, it smoke-tests the amd64 image — the OpenCode version must match the `Dockerfile` and the npm prefix must be writable by `agent`, which keeps in-sandbox self-updates working — then builds and pushes the multi-arch (amd64 + arm64) image to GHCR and Docker Hub with provenance attestations on both registries. Docs-only changes skip the build but the job still succeeds, so the required `build-and-push` check stays green. Manual runs (`workflow_dispatch`) always build; if the diff base is unavailable (new branch, missing commit), the build runs conservatively.

## Registry cleanup

`cleanup-registry.yml` runs weekly and removes untagged images older than 30 days while preserving tagged images and their multi-arch components. Cleanup is opt-in: run the workflow manually in dry-run mode to inspect candidates, then set the repository variable `GHCR_CLEANUP_ENABLED=true` to enable automatic weekly deletion.

To remove old `sha-*`, `main`, and `pr-*` tags once, run the workflow manually with `legacy_tags` checked: inspect the default dry run, then repeat with `dry_run` unchecked. This removes only the matching tags, even if an image also has a version tag or `latest`; no new legacy tags are published.

## Renovate

Renovate opens PRs for the OpenCode version, the base image digest, and GitHub Actions (see `renovate.json`). Low-risk updates (base image digest, OpenCode minor/patch, action minor/patch/digest) automerge once CI passes. Majors are manual: an OpenCode major (v3 or later) waits in the Renovate dependency dashboard until you approve it there, and action majors arrive as regular PRs to review and merge.
