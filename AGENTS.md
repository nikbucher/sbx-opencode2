# AGENTS.md

Guidelines for AI coding agents (and humans) working in this repository.

## Markdown style

Write Markdown as flowing text: one paragraph per line, no hard line wraps to an artificial width (no 72/80-column text layout). Renderers and editors soft-wrap, and screens are wide. Keep blank lines between paragraphs, keep list items and table rows on a single line, and never re-wrap untouched lines in a diff.

## Commits

Follow Conventional Commits: `feat:`, `fix:`, `ci:`, `docs:`, `chore:` — imperative mood, lowercase after the type. Squash related work into one commit instead of stacking fix-up commits.

## Dependencies & releases

Renovate opens dependency PRs (pinned OpenCode v2, base image digest, GitHub Actions) and automerges low-risk updates once CI passes — don't revert them without checking CI. Releases are git tags `v<version>` that must match `ARG OPENCODE_VERSION` in the `Dockerfile` (tag without the `v` prefix); CI smoke-tests and pushes the image to GHCR.
