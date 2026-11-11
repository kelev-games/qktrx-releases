# qktrx-releases
Public downloads and release notes for qktrx.

[Download qktrx 0.1.1-beta.6 for Apple silicon Macs](https://github.com/kelev-games/qktrx-releases/releases/download/v0.1.1-beta.6/qktrx-0.1.1-beta.6-darwin-arm64.dmg)

[Release notes and checksums](https://github.com/kelev-games/qktrx-releases/releases/tag/v0.1.1-beta.6)

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
