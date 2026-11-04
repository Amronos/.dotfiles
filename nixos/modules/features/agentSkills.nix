{ ... }:
{
  flake.nixosModules.agentSkills =
    { lib, pkgs, ... }:
    let
      # A live checkout instead of a store path so `npx skills add/update` can write to it.
      cloneSkills = pkgs.writeShellScript "clone-agent-skills" ''
        set -euo pipefail
        export PATH=${
          lib.makeBinPath [
            pkgs.coreutils
            pkgs.git
          ]
        }

        skillsDir="$HOME/.agents/skills"
        [ -d "$skillsDir/.git" ] && exit 0
        if [ -e "$skillsDir" ]; then
          echo "$skillsDir exists but is not a git checkout; move it aside to clone." >&2
          exit 1
        fi
        git clone https://github.com/Amronos/skills.git "$skillsDir"
      '';
    in
    {
      systemd.user.tmpfiles.rules = [
        "L+ %h/.agents/.skill-lock.json - - - - skills/.skill-lock.json"
      ];

      systemd.user.services.agent-skills = {
        description = "Clone agent skills into ~/.agents/skills";
        wantedBy = [ "default.target" ];
        after = [ "systemd-tmpfiles-setup.service" ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = "${cloneSkills}";
        };
      };
    };
}
