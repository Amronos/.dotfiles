# Global agent instructions

Edit [AGENTS.md](AGENTS.md) here, then rebuild NixOS. Both hosts include the
`agentInstructions` module through `editorsMinimal`.

The module links these files to the same instructions in the Nix store:

| Tool | User instruction file |
| --- | --- |
| Shared agents directory | `~/.agents/AGENTS.md` |
| [Codex](https://learn.chatgpt.com/docs/agent-configuration/agents-md) | `~/.codex/AGENTS.md` |
| [Claude Code](https://code.claude.com/docs/en/memory) | `~/.claude/CLAUDE.md` |
| [OpenCode](https://opencode.ai/docs/rules/) | `~/.config/opencode/AGENTS.md` |
| [Cursor](https://cursor.com/help/customization/rules) | `~/.cursor/rules/global-agent-instructions.mdc` |

Cursor's rule is generated from the same file with `alwaysApply: true`
frontmatter. The installed Cursor CLI scans ancestor directories for rules, so
the home rule applies to projects inside your home directory. For projects
outside your home, also set the instructions in Cursor's global User Rules.

User tmpfiles installs the links at login. To apply them in an existing session
after rebuilding, run:

```sh
systemctl --user restart systemd-tmpfiles-setup.service
```

These paths are managed by Nix and existing files at these exact paths are
replaced. Make changes in this repository; rebuilding updates all installed
copies. Other rules and settings in the tool directories are preserved, as are
existing directory permissions. OpenCode uses the user configuration directory
(`XDG_CONFIG_HOME`, defaulting to `~/.config`). Custom `CODEX_HOME` or
`CLAUDE_CONFIG_DIR` locations need corresponding path changes in the module.
A Codex `AGENTS.override.md` takes precedence over its `AGENTS.md`.
