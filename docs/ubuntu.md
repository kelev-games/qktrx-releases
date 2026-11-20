# Quack Tracks on Ubuntu

The qktrx 0.1.2 desktop beta is available for **Ubuntu 24.04 (amd64)** through
Kelev Games’ signed APT repository. Access is restricted to approved testers.
For first-time setup, ask the qktrx release operator for access and the signed
repository configuration, including the signing key and APT credentials.

## Install or update from APT

On a machine with the qktrx repository already configured:

```sh
sudo apt-get update
apt-cache policy qktrx
sudo apt-get install qktrx
dpkg-query -W qktrx
```

Check that `apt-cache policy qktrx` shows candidate `0.1.2` from the qktrx
repository. The same install command upgrades an existing 0.1.1 installation.
The 0.1.1 → 0.1.2 upgrade was tested through the signed feed, including playback
and recovery of an unsaved editor checkpoint. If APT returns `401`, ask the
release operator to check your repository access.

## Snap Store

The public Snap release is pending. The restricted APT channel is the current
Ubuntu desktop installation path for approved testers.

## CLI and MCP on Ubuntu

The public companion is installed separately. It requires Bun and connects to
the running qktrx editor. Follow the [companion setup guide](companion.md).
