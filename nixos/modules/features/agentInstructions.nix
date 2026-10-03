{ ... }:
{
  flake.nixosModules.agentInstructions =
    { pkgs, ... }:
    let
      instructions = ../../../agents/AGENTS.md;
      cursorRule = pkgs.writeText "global-agent-instructions.mdc" (
        ''
          ---
          description: Global agent instructions
          globs: "**/*"
          alwaysApply: true
          ---

        ''
        + builtins.readFile instructions
      );
      directories = [
        "%h/.agents"
        "%h/.codex"
        "%h/.claude"
        "%h/.cursor"
        "%h/.cursor/rules"
        "%E"
        "%E/opencode"
      ];
    in
    {
      systemd.user.tmpfiles.rules = map (directory: "d ${directory} :0700 - - -") directories ++ [
        "L+ %h/.agents/AGENTS.md - - - - ${instructions}"
        "L+ %h/.codex/AGENTS.md - - - - ${instructions}"
        "L+ %h/.claude/CLAUDE.md - - - - ${instructions}"
        "L+ %h/.cursor/rules/global-agent-instructions.mdc - - - - ${cursorRule}"
        "L+ %E/opencode/AGENTS.md - - - - ${instructions}"
      ];
    };
}
