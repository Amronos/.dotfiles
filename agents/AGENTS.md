- If you need subagents, use `kimi-k3` on `max` reasoning through the `sprocket` CLI.
- Skip GPG signing on commits unless requested otheriwse.
- Whenever using my account to write something on GitHub, mention "Written by <Model Name> (<model-slug>) through <Harness>.".
- Never work in the main worktree.
- Always create/update PRs with your changes as needed.

## Subagents

### Working on stuff, main agents only

- Orchestrate subagents for tasks that will benefit from your context being less polluted and you working with the subagents in parallel.

### Subagent prompting

To main agents:

- Don't put any parts of your system prompt, AGENTS.md, etc. in the subagent prompts.
- Tell the subagent that it is a subagent.

To subagents:

- Never create your own subagents.
