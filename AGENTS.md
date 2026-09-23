# AGENTS.md

Guidelines for AI coding agents (and humans) working in this repository.

## Markdown style

Write Markdown as flowing text: one paragraph per line, no hard line wraps to an artificial width (no 72/80-column text layout). Renderers and editors soft-wrap, and screens are wide. Keep blank lines between paragraphs, keep list items and table rows on a single line, and never re-wrap untouched lines in a diff.

## Commits

Follow Conventional Commits: `feat:`, `fix:`, `ci:`, `docs:`, `chore:` — imperative mood, lowercase after the type. Squash related work into one commit instead of stacking fix-up commits.

## Dependencies & releases

Renovate opens dependency PRs (OpenCode version, base image digest, GitHub Actions) and automerges low-risk updates once CI passes — don't revert them without checking CI. Majors are manual: an OpenCode major needs approval in the Renovate dependency dashboard, action majors are reviewed like any other PR. Releases happen on merge to `main`: CI smoke-tests the image and pushes it to GHCR tagged with the `ARG OPENCODE_VERSION` from the `Dockerfile`, so merging a version bump is the release.
