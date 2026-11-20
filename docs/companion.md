# Use qktrx with Codex or the terminal

The companion lets an AI assistant see and work with a course you have open
in qktrx. It also adds a terminal command, `qktrx-agent`, for people who
prefer to work that way. If you just want to make and playtest courses, you
can use [the editor](../README.md) on its own.

## Get set up

You’ll need qktrx **0.1.2**, a Mac or Ubuntu computer, and a small program
called **Bun** that runs the companion. Bun 1.3.10 is the version we tested.

1. [Install Bun](https://bun.com/docs/installation).
2. [Download the companion](https://github.com/kelev-games/qktrx-releases/releases/download/companion-v0.1.5/qktrx-companion-0.1.5-macos-linux.tar.gz)
   and extract it to a folder you can keep.
3. Open qktrx on the same computer and open a course.

## Add the companion to Codex

In Terminal, go to the folder you extracted, the one that contains
`qktrx-agent`. Run these two commands.

```sh
codex plugin marketplace add "$PWD"
codex plugin add qktrx@qktrx-codex
```

Start a new Codex session and ask **“Which course do I have open in qktrx?”**
If Codex can’t connect, check the connection help below.

## Use the terminal command

This command lists your open courses. Run it from the extracted folder.

```sh
./qktrx-agent sessions
```

Run `./qktrx-agent --help` to see more commands. Keep `qktrx-agent` and
`agent.js` together if you move the folder.

## If it can’t connect

- **Bun is missing.** Try `bun --version` in Terminal. If you installed Bun
  in a custom location, set `QKTRX_BUN` to the full path of the Bun executable
  before starting Codex or running `qktrx-agent`.
- **The list is empty.** Open a course in qktrx and try again.
- **The tool says `NOT_PAIRED` or can’t reach the editor.** Start qktrx under
  the same user account as Codex. If qktrx is already running, it may use a
  different local address. See the steps below.

<details>
<summary>Find and select the editor's local address</summary>

The companion tries `http://127.0.0.1:4190` by default. To list saved editor
addresses and the paths to their private connection files, run the following
command.

```sh
bun -e '
  const dir = process.env.QKTRX_AGENT_CONFIG_DIR ??
    `${process.env.HOME}/.config/qktrx/agent`;
  for (const file of new Bun.Glob("*.json").scanSync(dir)) {
    const path = `${dir}/${file}`;
    const { appUrl } = await Bun.file(path).json();
    if (typeof appUrl === "string") console.log(appUrl, path);
  }
'
```

If several entries appear, try the file for the running editor. For a custom
qktrx profile, use the private connection file for that profile.

```sh
./qktrx-agent --connection "/absolute/path/to/pairing-file.json" sessions
```

Once that works, use the same file to start Codex.

```sh
QKTRX_AGENT_CONNECTION="/absolute/path/to/pairing-file.json" codex
```

If you already know the editor’s local address, you can pass it instead.
Replace the example port with yours.

```sh
QKTRX_APP_URL=http://127.0.0.1:4250 codex
```

</details>

<details>
<summary>Use the companion with Claude Code</summary>

Run this command from the extracted folder to start Claude Code.

```sh
claude --plugin-dir "$PWD/plugins/claude-code"
```

The plugin’s connection launcher passed testing. The full Claude Code
installation flow is still unverified.

</details>

<details>
<summary>Check your download and see what was tested</summary>

Download `SHA256SUMS` from the release page to the same folder as the archive.
Run the command for your computer and look for `OK`.

```sh
# Mac
shasum -a 256 -c SHA256SUMS

# Ubuntu
sha256sum -c SHA256SUMS
```

We tested Codex installation and a tool call against a running qktrx editor on
an Apple silicon Mac. On Ubuntu x64, we tested the terminal command, Codex
installation, and a tool call against a test service. Third-party licenses are
in the archive’s `licenses/` folder and in each plugin folder.

[Companion 0.1.5 release notes and downloads](https://github.com/kelev-games/qktrx-releases/releases/tag/companion-v0.1.5)

</details>
