{ ... }:
{
  flake.nixosModules.agentInstructions =
    { lib, pkgs, ... }:
    let
      instructions = ../../../agents/AGENTS.md;
      cursorRule = pkgs.writeText "global-agent-instructions.mdc" (
        ''
          ---
          description: Global agent instructions
          alwaysApply: true
          ---

        ''
        + builtins.readFile instructions
      );
      cursorPluginManifest = pkgs.writeText "plugin.json" (
        builtins.toJSON {
          name = "global-agent-instructions";
          description = "Shared global agent instructions";
          version = "1.0.0";
        }
      );
      # Cursor skips nix-store symlinks for ~/.cursor/rules and local plugins.
      installCursorInstructions = pkgs.writeShellScript "install-cursor-agent-instructions" ''
        set -euo pipefail
        export PATH=${lib.makeBinPath [ pkgs.coreutils ]}
        umask 077

        rulesDir="$HOME/.cursor/rules"
        pluginDir="$HOME/.cursor/plugins/local/global-agent-instructions"

        mkdir -p "$rulesDir"
        rm -f "$rulesDir/global-agent-instructions.mdc"
        cp --no-preserve=mode,ownership ${cursorRule} "$rulesDir/global-agent-instructions.mdc"

        rm -rf "$pluginDir"
        mkdir -p "$pluginDir/.cursor-plugin" "$pluginDir/rules"
        cp --no-preserve=mode,ownership ${cursorPluginManifest} "$pluginDir/.cursor-plugin/plugin.json"
        cp --no-preserve=mode,ownership ${cursorRule} "$pluginDir/rules/global-agent-instructions.mdc"
      '';
      directories = [
        "%h/.agents"
        "%h/.codex"
        "%h/.claude"
        "%h/.cursor"
        "%h/.cursor/rules"
        "%h/.cursor/plugins"
        "%h/.cursor/plugins/local"
        "%E"
        "%E/opencode"
      ];
    in
    {
      systemd.user.tmpfiles.rules = map (directory: "d ${directory} :0700 - - -") directories ++ [
        "L+ %h/.agents/AGENTS.md - - - - ${instructions}"
        "L+ %h/.codex/AGENTS.md - - - - ${instructions}"
        "L+ %h/.claude/CLAUDE.md - - - - ${instructions}"
        "L+ %E/opencode/AGENTS.md - - - - ${instructions}"
      ];

      systemd.user.services.cursor-global-agent-instructions = {
        description = "Install Cursor global agent instructions as regular files";
        wantedBy = [ "default.target" ];
        after = [ "systemd-tmpfiles-setup.service" ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = "${installCursorInstructions}";
        };
      };
    };
}
