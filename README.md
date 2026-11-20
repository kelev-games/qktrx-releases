# Quack Tracks releases

Quack Tracks (qktrx) is the level editor for 13 Duck Race. This repository
publishes the desktop editor and its optional CLI and MCP companion.

| Download | Version | Setup |
| --- | --- | --- |
| [Desktop editor for Apple silicon Macs](https://github.com/kelev-games/qktrx-releases/releases/download/v0.1.2/qktrx-0.1.2-darwin-arm64.dmg) | 0.1.2 beta | [Editor release notes and checksums](https://github.com/kelev-games/qktrx-releases/releases/tag/v0.1.2) |
| Desktop editor for Ubuntu 24.04 (amd64) | 0.1.2 restricted APT | [APT setup and Snap Store status](docs/ubuntu.md) |
| [CLI and MCP companion for macOS and Linux](https://github.com/kelev-games/qktrx-releases/releases/download/companion-v0.1.5/qktrx-companion-0.1.5-macos-linux.tar.gz) | 0.1.5 prerelease | [Install and connect the companion](docs/companion.md) · [Companion release notes and checksums](https://github.com/kelev-games/qktrx-releases/releases/tag/companion-v0.1.5) |

The companion connects to a running qktrx 0.1.2 editor. Install Bun separately
(Bun 1.3.10 was tested). The archive includes `qktrx-agent`, plugins for Codex
and Claude Code, and third-party license notices. The Ubuntu desktop beta is
available through the signed APT feed for approved testers. The Snap Store
release is pending.

### CI publication for macOS

Dispatch **Publish QA-approved macOS candidate** on `main` after native QA.
Use the version, source run, archive attempt, and exact manifest SHA-256 from the
private archive job summary. Include the successful QA run link and
user-facing release notes. The environment reviewer checks that QA covered
that exact manifest before approving publication.

The runner downloads the signed installer, updater ZIP, and manifest directly
from private Cloud Storage. It verifies them, uploads to a draft, checks the
hosted asset digests, and publishes the draft. Feed promotion is a separate
operation. The workflow can resume its own draft for the same manifest.
