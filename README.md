# HamadaSalhab's Homebrew tap

Install [agent-sync](https://github.com/HamadaSalhab/agent-sync), an experimental conversation sync CLI for Claude Code and Codex:

```sh
brew trust --formula hamadasalhab/tap/agent-sync
brew install HamadaSalhab/tap/agent-sync
agent-sync --version
```

Homebrew 7 requires explicit trust for third-party formulae. On older Homebrew versions without `brew trust`, omit the first line.

Supported through Homebrew on macOS and Linux. The formula installs its Python runtime and uses Git. Install Codex separately for native Codex history/title restoration, and git-crypt if you want optional encryption.

## Updating

```sh
brew update
brew upgrade HamadaSalhab/tap/agent-sync
```

Installation and upgrades do not sync conversations or change existing configuration or machine identity. Connect each computer independently to your own **private** data repository, following the [tool's setup instructions](https://github.com/HamadaSalhab/agent-sync#first-machine). Do not reinitialize an already configured computer. Close the agents before syncing.

This is a third-party tap, not Homebrew/core. Version 0.1.5 is an experimental release; review the tool's compatibility notes and keep backups.

## Attribution and license

agent-sync is a fork and evolution of [porkchop's Claude Code Conversation Sync](https://github.com/porkchop/claude-code-sync). Its original Git history, MIT copyright notice, and author attribution are retained in the [source repository](https://github.com/HamadaSalhab/agent-sync/blob/main/NOTICE.md). This tap's packaging is MIT licensed.

## Maintainers

The formula uses a versioned GitHub release archive with a SHA-256 checksum. To release an update, publish the tested tool tag and archive, update the formula's URL/checksum, then run:

```sh
brew style HamadaSalhab/tap/agent-sync
brew audit --strict HamadaSalhab/tap/agent-sync
brew reinstall --build-from-source HamadaSalhab/tap/agent-sync
brew test HamadaSalhab/tap/agent-sync
```

The formula test backs up, pushes, and restores synthetic data between isolated homes using a local Git remote. It does not access real conversations or start model turns.
