# Install the qktrx CLI and MCP companion

Companion 0.1.5 works with qktrx editor 0.1.2. Run the companion on the machine
that runs the editor for automatic local pairing. Keep a level open to see it
in the session list.

## Download and verify

1. [Install Bun](https://bun.com/docs/installation) and run `bun --version`.
   The companion was tested with Bun 1.3.10.
2. Download the archive and `SHA256SUMS` to the same folder.
   [Companion 0.1.5 release](https://github.com/kelev-games/qktrx-releases/releases/tag/companion-v0.1.5)
3. From that folder, verify and extract the archive.

   ```sh
   # macOS
   shasum -a 256 -c SHA256SUMS

   # Ubuntu
   sha256sum -c SHA256SUMS
   ```

   After you see `OK`, extract the bundle to a directory you can keep and try
   the CLI.

   ```sh
   mkdir -p qktrx-companion
   tar -xzf qktrx-companion-0.1.5-macos-linux.tar.gz -C qktrx-companion
   cd qktrx-companion
   ./qktrx-agent --help
   ```

Keep `qktrx-agent` and `agent.js` together. You can add their directory to
your `PATH` for CLI use. The launcher checks `~/.bun/bin/bun` and then
`PATH`. Set `QKTRX_BUN` to an absolute executable path to use a custom Bun
installation.

## Connect to the editor

Start qktrx under the same user account and try:

```sh
./qktrx-agent sessions
```

The default origin is `http://127.0.0.1:4190`. If the editor uses another
port, pass its origin with `--app-url` or choose its pairing file with
`--connection`. The following command prints the origins and paths from the
default pairing directory while keeping credential contents private:

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

If several entries are present, choose the one for the running editor. Old
entries can point to editors that are no longer running. For an editor using
a custom profile, use its private pairing file directly:

```sh
./qktrx-agent --connection "/absolute/path/to/pairing-file.json" sessions
```

Use the returned session ID with `./qktrx-agent context SESSION_ID`.
A successful response with an empty list means the editor has no registered
level tab. Open a level and retry.

## Install in Codex

From the extracted `qktrx-companion` directory:

```sh
codex plugin marketplace add "$PWD"
codex plugin add qktrx@qktrx-codex
```

Start a new Codex session and call the qktrx `list_sessions` tool. For a
nondefault origin, pass the origin to the process that starts Codex. For
example, if the editor is listening on port 4250:

```sh
QKTRX_APP_URL=http://127.0.0.1:4250 codex
```

You can also launch Codex with
`QKTRX_AGENT_CONNECTION=/absolute/path/to/pairing-file.json` to select the
exact profile. Codex forwards these variables and `QKTRX_BUN` to the plugin.
When using a graphical launcher, settings must be available to the launched
process. A terminal-only export applies to Codex started from that terminal.

If the server fails to start, verify Bun is installed in `~/.bun/bin`,
available to the host on `PATH`, or set with `QKTRX_BUN`. If the tool
reports `NOT_PAIRED`, check the running editor's origin and pairing file
with the CLI first.

## Claude Code

For a local Claude Code session, the archive includes a plugin at
`plugins/claude-code`:

```sh
claude --plugin-dir "$PWD/plugins/claude-code"
```

Its launcher passed MCP protocol tests. Installation in the Claude Code host
remains unverified.

## Verification and licenses

Codex plugin installation and a read-only MCP call passed on macOS Apple
silicon against qktrx 0.1.2. On Ubuntu x64, the CLI and Codex plugin passed
startup and an authenticated MCP call against a local test endpoint. Third-party
license texts are included in `licenses/` in the archive and in each plugin.
