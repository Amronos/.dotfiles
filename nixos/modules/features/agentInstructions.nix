{ ... }:
{
  flake.nixosModules.agentInstructions =
    { ... }:
    let
      instructions = ../../../agents/AGENTS.md;
      directories = [
        "%h/.agents"
        "%h/.codex"
        "%h/.claude"
        "%h/.config"
        "%h/.config/opencode"
      ];
    in
    {
      systemd.user.tmpfiles.rules = map (directory: "d ${directory} :0700 - - -") directories ++ [
        "L+ %h/.agents/AGENTS.md - - - - ${instructions}"
        "L+ %h/.codex/AGENTS.md - - - - ${instructions}"
        "L+ %h/.claude/CLAUDE.md - - - - ${instructions}"
        "L+ %h/.config/opencode/AGENTS.md - - - - ${instructions}"
      ];
    };
}
