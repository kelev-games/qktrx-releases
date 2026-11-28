# Get qktrx on Ubuntu

qktrx is the course editor for [13 Duck Race](https://13duckrace.com/).
The Ubuntu beta runs on Ubuntu 24.04 computers with a 64-bit Intel or AMD
processor. A public Snap Store download is still pending.

## Joining the beta

If you’re testing with Kelev Games, ask your qktrx contact for access and
setup instructions. The team will help you connect Ubuntu’s package manager
(APT) to the tester download channel.

## Installing or updating

For the 0.1.3 beta, a host operator needs to install the updated qktrx
archive keyring. If APT reports a missing public key, ask the operator to
refresh the keyring using the team’s verified setup instructions.

Before updating from 0.1.2, back up maps that use the retired Gate exit
section and remove that section in 0.1.2. In 0.1.3, place a Taper facing
the desired direction.

After the tester channel is set up, open **Terminal** and run these two
commands. The first refreshes Ubuntu’s list of available apps. The second
installs qktrx or updates your existing copy.

```sh
sudo apt-get update
sudo apt-get install qktrx
```

When it finishes, open **qktrx** from your apps menu. The current beta is
**0.1.3**.

If Ubuntu says it can’t find qktrx, check with your qktrx contact that the
tester channel is set up. If it says **401 Unauthorized**, ask them to check
your access.

If you want an AI assistant to work with your open course, see the
[optional companion guide](companion.md).
