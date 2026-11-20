# Publish a macOS release

Dispatch **Publish QA-approved macOS candidate** on `main` after native QA.
Use the version, source run, archive attempt, and exact manifest SHA-256 from the
private archive job summary. Include the successful QA run link and
user-facing release notes. The environment reviewer checks that QA covered
that exact manifest before approving publication.

The runner downloads the signed installer, updater ZIP, and manifest directly
from private Cloud Storage. It verifies them, uploads to a draft, checks the
hosted asset digests, and publishes the draft. Feed promotion is a separate
operation. The workflow can resume its own draft for the same manifest.

## Update the Homebrew cask

After the signed candidate has passed native QA and been promoted to the public
beta feed, update `version` and `sha256` together in
[`Casks/qktrx.rb`](../Casks/qktrx.rb). Take the DMG checksum from the matching
GitHub release manifest and verify the public download before merging the cask
update. The cask uses the existing installer asset. The in-app updater uses its
own feed.

Check the cask with `brew style --cask kelev-games/qktrx-releases/qktrx` and test
the candidate from an isolated test tap with
`brew install --cask --require-sha --appdir <test-directory> <test-tap>/qktrx`. To update a Homebrew-managed installation explicitly,
use `brew upgrade --cask --greedy kelev-games/qktrx-releases/qktrx`.
